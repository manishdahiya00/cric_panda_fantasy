module API
  module CashApp
    module V1
      # Defaults
      module Defaults
        extend ActiveSupport::Concern
        NEW_USER_AMT = 5
        INVITE_AMT = 5
        INVITE_COIN = 500
        MAX_IP_COUNT = 10
        MSG_SUCCESS = "Success"
        MSG_ERROR = "Internal Server Error"
        BLOCKED = "You Blocked, Max Limit"
        GBLOCKED = "Sorry! Scripts/Tricks not Allowed"
        INVALID_USER = 'Invalid UserId/Token'
        TOKEN = ['***','****']

        included do
          prefix 'api'
          version 'v1', using: :path
          default_format :json
          format :json
          #formatter :json, Grape::Formatter::ActiveModelSerializers

          helpers do
            def permitted_params
              @permitted_params ||= declared(params, include_missing: false)
            end

            def logger
              Rails.logger
            end

            def valid_user(user_id, security_token)
              user = User.where("id = ? AND security_token = ?", user_id, security_token).first
              if user
                return user
              else
                return false
              end
            end

            def apply_filters(data, filtertype)
              k=data.split(",")

              contests_relation=nil
              # contests=[]

              k.each do |filter|

              f=filter.split(/-|&/)

              case filtertype
              when "entry"
                contests = Contest.where("CAST(entry_fee AS INTEGER) BETWEEN ? AND ?", f[0], f[1])
              when "teams"
                if filter =~ /[-&]/
                contests = Contest.where("CAST(total_spot AS INTEGER) BETWEEN ? AND ?", f[0], f[1])
                else
                contests = Contest.where(total_spot: filter)
                end
              when "prizePool"
                contests = Contest.where("CAST(winning_prize AS INTEGER) BETWEEN ? AND ?", f[0], f[1])
              else
                if filter == "Single Entry"
                contests = Contest.where(entry_allowed: "Single")
                else
                contests = Contest.where(entry_allowed: "Multiple")
                end
              end

                if contests_relation.nil?
                  contests_relation = contests
                else
                  contests_relation = contests_relation.or(contests)
                end
              end

              return contests_relation
            end

            def most_contest_joined
              user_id_frequencies = UserContest.group(:user_id).count
              sorted_user_id_frequencies = user_id_frequencies.sort_by { |_, frequency| -frequency }
              user_data_with_rank = []
              current_rank = 1
              prev_frequency = nil
              sorted_user_id_frequencies.each do |user_id, frequency|
                if prev_frequency && frequency < prev_frequency
                  current_rank += 1
                end
                user_data_with_rank << {
                  userId: user_id,
                  userName: User.find(user_id).social_name,
                  userImage: User.find(user_id).social_imgurl,
                  userRank: current_rank,
                  points: frequency
                }
                prev_frequency = frequency
              end
              user_data_with_rank
            end

            def most_user_referral
              utm_medium_frequencies = User.where.not(utm_medium: nil).group(:utm_medium).count
              sorted_utm_medium_frequencies = utm_medium_frequencies.sort_by { |_, referrals| -referrals }

              user_data_with_rank = {}
              current_rank = 1
              prev_referral = nil

              sorted_utm_medium_frequencies.each do |referral_code, referrals|
                if prev_referral && referrals < prev_referral
                  current_rank += 1
                end

                #user = User.find_by(referral_code: referral_code)
                user = User.all.sample
                if user.present?
                user_data_with_rank[referral_code] = {
                  userId: user.id,
                  userName: user.social_name,
                  userImage: user.social_imgurl,
                  userRank: current_rank,
                  points: referrals
                }
                end

                prev_referral = referrals
              end

              user_data_with_rank.values
            end

              # calculating player actual score
            def score_calculation(item)
                player_actual_data = {
                  pid: item["pid"],
                  name: item["name"],
                  role: item["role"],
                  rating: item["rating"],
                  point: item["point"],
                  starting11: item["starting11"] == "4" ? 1 : 0,
                  run: item["run"].to_i,
                  four: item["four"].to_i,
                  six: (item["six"].to_i) / 2,
                  sr: item["sr"] != "0" ? "Yes" : "No",
                  fifty: item["fifty"] != "0" ? 1 : 0,
                  duck: item["duck"] != "0" ? 1 : 0,
                  wkts: item["wkts"] != "0" ? (item["wkts"].to_i) / 25 : 0,
                  maidenover: item["maidenover"] != "0" ? 1 : 0,
                  er: item["er"] != "0" ? "Yes" : "No",
                  catch: item["catch"] != "0" ? (item["catch"].to_i) / 8 : 0,
                  runoutstumping: item["runoutstumping"] != "0" ? (item["runoutstumping"].to_i) / 12 : 0,
                  runoutthrower: item["runoutthrower"] != "0" ? (item["runoutthrower"].to_i) / 6 : 0,
                  runoutcatcher: item["runoutcatcher"] != "0" ? (item["runoutcatcher"].to_i) / 6 : 0,
                  directrunout: item["directrunout"] != "0" ? (item["directrunout"].to_i) / 12 : 0,
                  stumping: item["stumping"] != "0" ? (item["stumping"].to_i) / 12 : 0,
                  thirty: item["thirty"] != "0" ? 1 : 0,
                  bonus: item["bonus"] != "0" ? "Yes" : "No",
                  bonuscatch: item["bonuscatch"] != "0" ? 1 : 0,
                  bonusbowedlbw: item["bonusbowedlbw"] != "0" ? 1 : 0
                }

            end


            def playerhash(match_data,player,t,usr_team,team,status)
              player_hash = {
                playerId: player.id.to_i,
                playerName: player.title,
                playerShortName: player.short_name,
                playerImage: player.thumb_url,
                playerTeam: t.abbr,
                teamLogo: t.logo_url,
                playerRole: player_role_int(player.playing_role),
                mteam_player: player.team.abbr == usr_team.match.teama_shortname ? true : false ,
                playerCredits: player.fantasy_player_rating,
                playerPoints:  (status == "Scheduled" ? usr_team.total_point : player_points(match_data,team,player))
              }
              return player_hash
            end

            def point_sum(k,match_data,total_points,usr_team)

              # k=Player.find_by(id: ply.to_i)
              t=Team.find_by_id(k.team_id)

              if t.tid.to_i == match_data["response"]["teama"]["team_id"]

                if usr_team.captain_id.to_i == k.id.to_i
                  return total_points = total_points + player_points(match_data,"teama",k)*2
                elsif usr_team.vcaptain_id.to_i == k.id.to_i
                  return total_points = total_points + player_points(match_data,"teama",k)*1.5
                else
                  return total_points = total_points + player_points(match_data,"teama",k)
                end
              else
                if usr_team.captain_id.to_i == k.id.to_i
                  return total_points = total_points + player_points(match_data,"teamb",k)*2
                elsif usr_team.vcaptain_id.to_i == k.id.to_i
                  return total_points = total_points + player_points(match_data,"teamb",k)*1.5
                else
                  return total_points = total_points + player_points(match_data,"teamb",k)
                end
              end
            end

            def role_count(k,role)
              p=k.playing_role

                case p
                 when "wk"
                   role[0]=role[0]+1
                 when "bat"
                   role[1]=role[1]+1
                 when "all"
                   role[2]=role[2]+1
                 when "bowl"
                   role[3]=role[3]+1
                 else
                   ""
                end
                return role
            end

            def team_player_count(k,usr_team,t)
              if k.team.abbr == usr_team.match.teama_shortname
                 t[0]=t[0]+1
               else
                 t[1]=t[1]+1
               end
               return t
            end

            def player_points(match_data,team,player)

              k=match_data["response"]["points"]["#{team}"]["playing11"]

              if !k.nil?
                player_point = k.find { |hash| hash["pid"] == player.pid }
                if player_point.nil?
                  return 0
                else
                  return player_point["point"].to_i
                end
              else
                return 0
              end
            end

            # fetching player score points data
            def player_list(match_data,teamname,p,t)
              playerInfo={}
              k=match_data["response"]["points"]["#{teamname}"]["playing11"]
              r_hash = k.find { |hash| hash["pid"] == p.pid }
              if r_hash.nil?
                k = match_data["response"]["points"]["#{teamname}"]["substitute"]
                r_hash = k.find { |hash| hash["pid"] == p.pid }
              end
              actual_data= score_calculation(r_hash)
              points_data= r_hash
              playerHash=[]
              a=0

                  event_names=["Playing 11","Run Score","Boundary Hit","Six Hit","Strike Rate","Half Century Bonus","Dismissal on a Duck","Wickets Taken","Maiden Over","Economy Bonus","Catches","Runout(Stumping)","Runout(Thrower)","Runout(Catcher)","Runout(Direct Hit)","Stumping","30 Run bonus","Bonus","Bonus Catches","Bonus(LBW/Bowled)"]
                  # fetching each key and printing all the actual and points value with event name all in seperate hashes
                  actual_data.each_with_index do |(key, actual_value), index|

                    # Skip the first 5 elements
                    if index < 5
                      next
                    end
                    point_value = points_data["#{key}"]
                    result_hash = {
                      event: event_names[a],
                      actual: "#{actual_value}",
                      points: point_value
                    }
                    a=a+1
                    playerHash << result_hash
                  end
                  # playerInfo = {
                  #   # teama_shortname: t.abbr,
                  #   # team_logo_url: t.logo_url,
                  #   # player_name: p.title,
                  #   # player_role: p.playing_role,
                  #   # player_image: p.thumb_url,
                  #   # credit: p.fantasy_player_rating,
                  #   # total_points: points_data["point"],
                  #   player_data: playerHash
                  # }

              return playerHash
            end

            def api_params
              Rails.logger.info"API Params:#{params.inspect}"
            end

            def player_name(id)
              Player.find(id).title
            end

            def player_role_int(role)
              if role == 'wk'
                return 0
              elsif role == 'bat'
                return 1
              elsif role == 'all'
                return 2
              elsif role == 'bowl'
                return 3
              else
                return 2
              end
            end

          end

          rescue_from ActiveRecord::RecordNotFound do |e|
            error_response(message: e.message, status: 404)
          end

          rescue_from ActiveRecord::RecordInvalid do |e|
            error_response(message: e.message, status: 422)
          end
        end
      end
    end
  end

end
