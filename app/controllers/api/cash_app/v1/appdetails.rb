module API
  module CashApp
    module V1
      class Appdetails < Grape::API
        include API::CashApp::V1::Defaults

        UPIC = %w[
          https://lh3.googleusercontent.com/a/AEdFTp6TjUur5qgWhe5AQS6RqRjFvW_iAT4LYdumhgBW1Q=s96-c
          https://lh3.googleusercontent.com/a/AEdFTp5yGRjDSVCAUDRoMsLsGc0hw_B5IVlKXP2DnVdV5g=s96-c
          https://lh3.googleusercontent.com/a/AEdFTp7IF_HAhnlvmubAe-ywy8eJGgfeJyS1wpf9pQBIRw=s96-c
          https://lh3.googleusercontent.com/a/AEdFTp6Y9nZccAII1C_KvPggY_OzexoAy9f6pRoKiI0-=s96-c
          https://lh3.googleusercontent.com/a/AEdFTp7UJHXC47B4F7GWWhvwjjhHyvtvOvok2tdvjDF18A=s96-c
          https://lh3.googleusercontent.com/a/AEdFTp6ekCsBpPB7HzU_pdHfGF1-EKY6PpgHbIETclGT=s96-c
        ]

        LOGO = %w[
          https://i.pinimg.com/236x/ec/df/19/ecdf1972d73324a3ad66da3a20270d66.jpg
          https://i.pinimg.com/236x/22/09/d7/2209d77f03a412fade4c6e4e03175523.jpg
          https://i.pinimg.com/236x/6c/16/83/6c1683531b146d1df9a8f2992eb10598.jpg
          https://i.pinimg.com/236x/b3/c9/fc/b3c9fc9995cd8bfa26e9f57a6db6d70d.jpg
          https://i.pinimg.com/236x/b4/31/6a/b4316a26428881ad3bef6eb58d1677e0.jpg
        ]
        HEXCLR = %w[#8E44AD #E53935 #F1C40F #E74C3C #239B56]

        IMG = %w[
          https://www.purbat.com/wp-content/uploads/Melbourne-Cricket-Ground-MCG-%E2%80%93-Australia-most-beautiful-cricket-stadiums.jpg
          https://www.purbat.com/wp-content/uploads/Newlands-Cricket-Ground-Cape-Town-South-Africa-beautiful-cricket-stadiums.jpg
          https://www.purbat.com/wp-content/uploads/The-WACA-Perth-Australia-most-beautiful-cricket-stadiums.jpg
        ]
        ##################################################################
        # => No2 V1 Home Page Match List api
        ##################################################################
        resource :upcomingMatch do
          desc "Match List on Home API"
          before { api_params }

          post do
            begin
              user = valid_user(params["userId"].to_i, params["securityToken"])
              if user
                match_list = []
                #current_datetime = DateTime.now
                current_datetime = Time.zone.now
                formatted_current_datetime =
                  current_datetime.strftime("%Y-%m-%d %H:%M:%S")
                mat =
                  Match.all
                    .where(
                      "date_start_ist > ? AND mstatus_str = ?",
                      formatted_current_datetime,
                      "Scheduled"
                    ).limit(20)
                    .sort_by { |match| match.date_start_ist}

                mat.each do |mat|
                  front_team = {
                    team_id: mat.teama_id,
                    team_title: mat.teama_name,
                    short_name: mat.teama_shortname,
                    team_color: HEXCLR.sample,
                    team_logo: mat.teama_logourl
                  }
                  opp_team = {
                    team_id: mat.teamb_id,
                    team_title: mat.teamb_name,
                    short_name: mat.teamb_shortname,
                    team_color: HEXCLR.sample,
                    team_logo: mat.teamb_logourl
                  }
                  match_hash = {
                    match_id: mat.id,
                    match_title: mat.title,
                    match_status: mat.status,
                    match_time: mat.date_start_ist,
                    mega_prize: "₹#{rand(9)} Crores",
                    front_team: front_team,
                    opp_team: opp_team
                  }
                  # .to_datetime.strftime("%Y-%m-%d %l:%M:%S")
                  match_list << match_hash
                end
                {
                  message: MSG_SUCCESS,
                  status: 200,
                  matchList: match_list,
                  img: IMG
                }
              else
                { message: INVALID_USER, status: 500 }
              end
            rescue Exception => e
              logger.info "API Exception-#{Time.now}-upcomingMatch-#{params.inspect}-Error-#{e}"
              { message: MSG_ERROR, status: 500,error:e }
            end
          end
        end

        ##################################################################
        # => No5 V1 list match contest with prize
        ##################################################################
        resource :contestList do
          desc "Contest List API"
          before { api_params }

          params do
            requires :userId, type: String, allow_blank: false
            requires :securityToken, type: String, allow_blank: false
            requires :versionName, type: String, allow_blank: false
            requires :versionCode, type: String, allow_blank: false
            requires :matchId, type: String, allow_blank: false
          end

          post do
            begin
              user = valid_user(params["userId"].to_i, params["securityToken"])
              if user
                all_contests = []
                uteam =
                  UserTeam.where(
                    "user_id = ? AND match_id = ?",
                    params["userId"].to_i,
                    params["matchId"].to_i
                  ).size
                ucontest =
                  UserContest.where(
                    "user_id = ? AND match_id = ?",
                    params["userId"].to_i,
                    params["matchId"].to_i
                  ).size

                contest_categories = ContestCategory.active
                contest_categories.each do |contest_category|
                  act_contests = contest_category.contests.active
                  if act_contests.present?
                    contest_list = []
                    act_contests.each do |contest|
                      contest_hash = {
                        contest_id: contest.id,
                        contest_name: contest.title,
                        winning_prize: contest.winning_prize,
                        entry_fee: contest.entry_fee,
                        total_spots: contest.total_spot,
                        spots_left: "#{rand(contest.total_spot.to_i)}",
                        first_prize: contest.first_prize,
                        winning_percent: contest.winning_percentage,
                        entry_allowed: contest.entry_allowed,
                        entry_type: contest.entry_type
                      }
                      contest_list << contest_hash
                    end
                    contests_hash = {
                      contestCategory: contest_category.title,
                      contest_list: contest_list
                    }
                    all_contests << contests_hash
                  end
                end
                {
                  message: MSG_SUCCESS,
                  status: 200,
                  ucontest: ucontest,
                  uteam: uteam,
                  contests: all_contests
                }
              else
                { message: INVALID_USER, status: 500 }
              end
            rescue Exception => e
              logger.info "API Exception-#{Time.now}-contestList-#{params.inspect}-Error-#{e}"
              { message: MSG_ERROR, status: 500 }
            end
          end
        end

        ##################################################################
        # => No4 V1 Home Page Match List Api
        ##################################################################
        resource :userMatchContest do
          desc "Match List on Home API"
          before { api_params }

          params do
            requires :userId, type: String, allow_blank: false
            requires :securityToken, type: String, allow_blank: false
            requires :versionName, type: String, allow_blank: false
            requires :versionCode, type: String, allow_blank: false
            requires :matchId, type: String, allow_blank: false
          end

          post do
            begin
              user = valid_user(params["userId"].to_i, params["securityToken"])
              if user
                contests = []
                #user = User.find(params['userId'].to_i)
                #user_contests = user.user_contests
                user_contests =
                  UserContest.where(
                    "user_id = ? AND match_id = ?",
                    params["userId"].to_i,
                    params["matchId"].to_i
                  )

                user_contests.each do |usr_contest|
                  if !usr_contest.contest_id.nil?
                    contest_hash = {
                      contest_id: usr_contest.id,
                      contest_name: usr_contest.title,
                      captain_name: usr_contest.captain_name,
                      vice_captain: usr_contest.vcaptain_name,
                      total_spots: usr_contest.total_spot,
                      spots_left:
                        (
                          if !usr_contest.total_spot.nil?
                            "#{rand(usr_contest.total_spot.to_i)}"
                          else
                            usr_contest.total_spot
                          end
                        ),
                      prize_type: usr_contest.winning_prize,
                      entry_allowed: usr_contest.entry_allowed,
                      entry_type: usr_contest.entry_type
                    }
                    contests << contest_hash
                  end
                end
                { message: MSG_SUCCESS, status: 200, contests: contests }
              else
                { message: INVALID_USER, status: 500 }
              end
            rescue Exception => e
              logger.info "API Exception-#{Time.now}-userMatchContest-#{params.inspect}-Error-#{e}"
              { message: MSG_ERROR, status: 500 }
            end
          end
        end

        ##################################################################
        # => V1 Home Page Match List Api
        ##################################################################
        resource :contestRank do
          desc "Match List on Home API"
          before { api_params }

          params do
            requires :userId, type: String, allow_blank: false
            requires :securityToken, type: String, allow_blank: false
            requires :versionName, type: String, allow_blank: false
            requires :versionCode, type: String, allow_blank: false
            requires :contestId, type: String, allow_blank: false
          end

          post do
            begin
              user = valid_user(params["userId"].to_i, params["securityToken"])
              if user
                rank_list = []
                leader_list = []
                for a in 1..5
                  rank_hash = { id: (a), title: a, amount: (2011 + a) }
                  rank_list << rank_hash
                  leader_hash = {
                    id: (5 + a),
                    title: "Leader User-#{a}",
                    amount: "#{a + 1000}",
                    points: "#{a + 101}",
                    rank: (a + 5),
                    teamno: a,
                    image_url: UPIC.sample
                  }
                  leader_list << leader_hash
                end
                {
                  message: MSG_SUCCESS,
                  status: 200,
                  rankList: rank_list,
                  leaderList: leader_list
                }
              else
                { message: INVALID_USER, status: 500 }
              end
            rescue Exception => e
              logger.info "API Exception-#{Time.now}-contestRank-#{params.inspect}-Error-#{e}"
              { message: MSG_ERROR, status: 500 }
            end
          end
        end

        ##################################################################
        # => V1 Home Page Match List Api
        ##################################################################
        resource :contestPlayer do
          desc "Match List on Home API"
          before { api_params }

          params do
            requires :userId, type: String, allow_blank: false
            requires :securityToken, type: String, allow_blank: false
            requires :versionName, type: String, allow_blank: false
            requires :versionCode, type: String, allow_blank: false
            # requires :contestId, type: String, allow_blank: false
            requires :matchId, type: String, allow_blank: false
          end

          post do
            begin
              user = valid_user(params["userId"].to_i, params["securityToken"])
              if user
                player_list = []
                act_match = Match.find(params[:matchId].to_i)
                match_teams = act_match.match_teams
                match_teams.each do |mat|
                  player_rec = mat.player
                  player_hash = {
                    player_id: mat.player_id,
                    player_name: mat.name,
                    player_role: player_role_int(mat.role),
                    role_str: mat.role,
                    selectby: "#{rand(100)}",
                    points: player_rec.fantasy_player_rating.to_i,
                    credits: player_rec.fantasy_player_rating.to_f,
                    team_title: mat.team.abbr,
                    frontTeam: [true, false].sample
                  }
                  player_list << player_hash
                end
                { message: MSG_SUCCESS, status: 200, playerList: player_list }
              else
                { message: INVALID_USER, status: 500 }
              end
            rescue Exception => e
              logger.info "API Exception-#{Time.now}-contestPlayer-#{params.inspect}-Error-#{e}"
              { message: MSG_ERROR, status: 500 }
            end
          end
        end

        ##################################################################
        # => V1 Upcoming match team Api
        ##################################################################
        resource :userMatchTeam do
          desc "Match List on Home API"
          before { api_params }

          params do
            requires :userId, type: String, allow_blank: false
            requires :securityToken, type: String, allow_blank: false
            requires :versionName, type: String, allow_blank: false
            requires :versionCode, type: String, allow_blank: false
            requires :matchId, type: String, allow_blank: false
          end

          post do
            begin
              user = valid_user(params["userId"].to_i, params["securityToken"])
              if user
                team_list = []
                #user = User.find(params['userId'].to_i)
                #user_teams = user.user_teams
                user_teams =
                  UserTeam.where(
                    "user_id = ? AND match_id = ?",
                    params["userId"].to_i,
                    params["matchId"].to_i
                  )
                  user_contests =
                  UserContest.where(
                    "user_id = ? AND match_id = ?",
                    params["userId"].to_i,
                    params["matchId"].to_i
                  )
                  user_teams.each do |usr_team|
                  role = [0, 0, 0, 0]
                  team_count = [0, 0]

                  k = Player.find_by(id: usr_team.captain_id.to_i)
                                 role = role_count(k, role)
                  team_count = team_player_count(k, usr_team, team_count)

                  k = Player.find_by(id: usr_team.vcaptain_id.to_i)
                  role = role_count(k, role)
                  team_count = team_player_count(k, usr_team, team_count)

                  p = usr_team.player_ids
                  pl = p.split(",")
                  pl.each do |ply|
                    k = Player.find_by(id: ply.to_i)
                    role = role_count(k, role)
                    team_count = team_player_count(k, usr_team, team_count)
                  end

                  team_hash = {
                    id: usr_team.id,
                    username: user.social_name,
                    mteam_short: usr_team.match.teama_shortname,
                    oteam_short: usr_team.match.teamb_shortname,
                    mteam_player: team_count[0],
                    oteam_player: team_count[1],
                    mteam_cap:
                      (
                        if Player.find_by(id: usr_team.captain_id).team.abbr ==
                             usr_team.match.teama_shortname
                          true
                        else
                          false
                        end
                      ),
                    mteam_vcap:
                      (
                        if Player.find_by(id: usr_team.vcaptain_id).team.abbr ==
                             usr_team.match.teama_shortname
                          true
                        else
                          false
                        end
                      ),
                    captain_name: player_name(usr_team.captain_id),
                    vice_captain: player_name(usr_team.vcaptain_id),
                    wkp: role[0],
                    bat: role[1],
                    alr: role[2],
                    bowl: role[3]
                  }
                  team_list << team_hash
                end
                { message: MSG_SUCCESS, status: 200, uteamList: team_list }
              else
                { message: INVALID_USER, status: 500 }
              end
            rescue Exception => e
              logger.info "API Exception-#{Time.now}-userMatchTeam-#{params.inspect}-Error-#{e}"
              { message: MSG_ERROR, status: 500 }
            end
          end
        end

        ##################################################################
        # => V1 user Team preview
        ##################################################################
        resource :myMatches do
          desc "Match List on Home API"
          before { api_params }

          params do
            requires :userId, type: String, allow_blank: false
            requires :securityToken, type: String, allow_blank: false
            requires :versionName, type: String, allow_blank: false
            requires :versionCode, type: String, allow_blank: false
            #requires :contestId, type: String, allow_blank: false
            requires :status, type: String, allow_blank: false
          end

          post do
            begin
              user = valid_user(params["userId"].to_i, params["securityToken"])
              if user
                match_list = []

                user_teams = UserTeam.where(user_id: params[:userId])

                user_teams.each do |rec|
                  mat = Match.find_by(id: rec.match_id)
                  front_team = {
                    team_id: mat.teama_id,
                    team_title: mat.teama_name,
                    short_name: mat.teama_shortname,
                    team_color: HEXCLR.sample,
                    team_logo: mat.teama_logourl
                  }
                  opp_team = {
                    team_id: mat.teamb_id,
                    team_title: mat.teamb_name,
                    short_name: mat.teamb_shortname,
                    team_color: HEXCLR.sample,
                    team_logo: mat.teamb_logourl
                  }
                  match_hash = {
                    match_id: mat.id,
                    match_title: mat.title,
                    match_status: mat.status,
                    front_team: front_team,
                    opp_team: opp_team
                  }
                  match_list << match_hash
                end
                { message: MSG_SUCCESS, status: 200, match_list: match_list }
              else
                { message: INVALID_USER, status: 500 }
              end
            rescue Exception => e
              logger.info "API Exception-#{Time.now}-myMatches-#{params.inspect}-Error-#{e}"
              { message: MSG_ERROR, status: 500 }
            end
          end
        end

        ##################################################################
        # => V1 user Team preview
        ##################################################################
        resource :myCompletedContests do
          desc "Match List on Home API"
          before { api_params }

          params do
            requires :userId, type: String, allow_blank: false
            requires :matchId, type: String, allow_blank: false
            requires :securityToken, type: String, allow_blank: false
            requires :versionName, type: String, allow_blank: false
            requires :versionCode, type: String, allow_blank: false
            #requires :status, type: String, allow_blank: false
            #requires :contestId, type: String, allow_blank: false
          end

          post do
            begin
              user = valid_user(params["userId"].to_i, params["securityToken"])
              if user
                contest_list = []
                score_hash = []
                m = Match.find_by(id: params["matchId"])
                require "rest-client"
                apiurl =
                  "https://rest.entitysport.com/v2/matches/#{m.mid}/newpoint2?token=3e0e77298ef32518821a2490c457300c"
                response = RestClient.get(apiurl, headers = { accept: :json })
                match_data = JSON.parse(response)
                # if m.mstatus_str == 'Completed'
                user_teams =
                  UserTeam.where(
                    user_id: params[:userId],
                    match_id: params[:matchId]
                  ).group(:contest_id)
                user_teams.each do |rec|
                  con = Contest.find_by(id: rec.contest_id)
                  con = Contest.first if !con.present?
                  ct = ContestCategory.find_by(id: con.contest_category_id)
                  uc = UserContest.find_by(user_team_id: rec.id)
                  uc = UserContest.first if !uc.present?
                  contest_hash = {
                    id: rec.id,
                    contestName: ct.title,
                    spots: con.total_spot,
                    isGuaranteed: true,
                    prizeType: con.first_prize,
                    entryType: con.entry_type,
                    teams: 1,
                    points: rec.total_point,
                    rank: uc.rank
                  }
                  contest_list << contest_hash
                end
                score_hash = {
                  mteamName: match_data["response"]["teama"]["short_name"],
                  mteamScore: match_data["response"]["teama"]["scores"],
                  mteamOvers: match_data["response"]["teama"]["overs"],
                  oteamName: match_data["response"]["teamb"]["short_name"],
                  oteamScore: match_data["response"]["teamb"]["scores"],
                  oteamOvers: match_data["response"]["teamb"]["overs"],
                  result: match_data["response"]["status_note"]
                }
                # else
                #     puts "match not completed"
                # end
                {
                  message: MSG_SUCCESS,
                  status: 200,
                  contestList: contest_list,
                  scoreHash: score_hash
                }
              else
                { message: INVALID_USER, status: 500 }
              end
            rescue Exception => e
              logger.info "API Exception-#{Time.now}-myCompletedContests-#{params.inspect}-Error-#{e}"
              { message: MSG_ERROR, status: 500 }
            end
          end
        end

        resource :userCompletedMatchTeam do
          desc "Match List on Home API"
          before { api_params }

          params do
            requires :userId, type: String, allow_blank: false
            # requires :securityToken, type: String, allow_blank: false
            # requires :versionName, type: String, allow_blank: false
            # requires :versionCode, type: String, allow_blank: false
            requires :matchId, type: String, allow_blank: false
          end

          post do
            begin
              mat = Match.find(params[:matchId])
              require "rest-client"
              apiurl =
                "https://rest.entitysport.com/v2/matches/#{mat.mid}/newpoint2?token=3e0e77298ef32518821a2490c457300c"
              response = RestClient.get(apiurl, headers = { accept: :json })
              match_data = JSON.parse(response)
              # user = valid_user(params['userId'].to_i, params['securityToken'])
              if true
                team_list = []
                user = User.find(params["userId"].to_i)
                #user_teams = user.user_teams
                user_teams =
                  UserTeam.where(
                    "user_id = ? AND match_id = ?",
                    params["userId"].to_i,
                    params["matchId"].to_i
                  )
                user_teams.each do |usr_team|
                  role = [0, 0, 0, 0]
                  team_count = [0, 0]
                  total_points = 0

                  # captain data
                  k = Player.find_by(id: usr_team.captain_id.to_i)
                  total_points =
                    point_sum(k, match_data, total_points, usr_team)
                  role = role_count(k, role)
                  team_count = team_player_count(k, usr_team, team_count)

                  # vcaptain data
                  k = Player.find_by(id: usr_team.vcaptain_id.to_i)
                  total_points =
                    point_sum(k, match_data, total_points, usr_team)
                  role = role_count(k, role)
                  team_count = team_player_count(k, usr_team, team_count)

                  # players data
                  p = usr_team.player_ids
                  pl = p.split(",")
                  pl.each do |ply|
                    k = Player.find_by(id: ply.to_i)
                    total_points =
                      point_sum(k, match_data, total_points, usr_team)
                    role = role_count(k, role)
                    team_count = team_player_count(k, usr_team, team_count)
                    p k.id
                  end

                  if usr_team.total_point != total_points
                    usr_team.update(total_point: total_points)
                  end

                  team_hash = {
                    id: usr_team.id,
                    teamName: usr_team.title,
                    username: user.social_name,
                    mteam_short: usr_team.match.teama_shortname,
                    oteam_short: usr_team.match.teamb_shortname,
                    points: usr_team.total_point,
                    mteam_player: team_count[0],
                    oteam_player: team_count[1],
                    mteam_cap:
                      (
                        if Player.find_by(id: usr_team.captain_id).team.abbr ==
                             usr_team.match.teama_shortname
                          true
                        else
                          false
                        end
                      ),
                    mteam_vcap:
                      (
                        if Player.find_by(id: usr_team.vcaptain_id).team.abbr ==
                             usr_team.match.teama_shortname
                          true
                        else
                          false
                        end
                      ),
                    captain_name: player_name(usr_team.captain_id),
                    vice_captain: player_name(usr_team.vcaptain_id),
                    wkp: role[0],
                    bat: role[1],
                    alr: role[2],
                    bowl: role[3]
                  }
                  team_list << team_hash
                end
                { message: MSG_SUCCESS, status: 200, uteamList: team_list }
              else
                { message: INVALID_USER, status: 500 }
              end
            rescue Exception => e
              logger.info "API Exception-#{Time.now}-userCompletedMatchTeam-#{params.inspect}-Error-#{e}"
              { message: MSG_ERROR, status: 500 }
            end
          end
        end

          #########################Live Match Data######################

          # resource :myLiveContests do
          #   desc "Match List on Home API"
          #   before { api_params }

          #   params do
          #     requires :userId, type: String, allow_blank: false
          #     requires :matchId, type: String, allow_blank: false
          #     requires :securityToken, type: String, allow_blank: false
          #     requires :versionName, type: String, allow_blank: false
          #     requires :versionCode, type: String, allow_blank: false
          #     #requires :status, type: String, allow_blank: false
          #     #requires :contestId, type: String, allow_blank: false
          #   end

          #   post do
          #     begin
          #       user = valid_user(params["userId"].to_i, params["securityToken"])
          #       if user
          #         contest_list = []
          #         score_hash = []
          #         m = Match.find_by(id: params["matchId"])
          #         require "rest-client"
          #         apiurl =
          #           "https://rest.entitysport.com/v2/matches/#{m.mid}/live?token=3e0e77298ef32518821a2490c457300c"
          #         response = RestClient.get(apiurl, headers = { accept: :json })
          #         match_data = JSON.parse(response)
          #         # if m.mstatus_str == 'Completed'
          #         user_teams =
          #           UserTeam.where(
          #             user_id: params[:userId],
          #             match_id: params[:matchId]
          #           ).group(:contest_id)
          #         user_teams.each do |rec|
          #           con = Contest.find_by(id: rec.contest_id)
          #           con = Contest.first if !con.present?
          #           ct = ContestCategory.find_by(id: con.contest_category_id)
          #           uc = UserContest.find_by(user_team_id: rec.id)
          #           uc = UserContest.first if !uc.present?
          #           contest_hash = {
          #             id: rec.id,
          #             contestName: ct.title,
          #             spots: con.total_spot,
          #             isGuaranteed: true,
          #             prizeType: con.first_prize,
          #             entryType: con.entry_type,
          #             teams: 1,
          #             points: rec.total_point,
          #             rank: uc.rank
          #           }
          #           contest_list << contest_hash
          #         end
          #         score_hash = {
          #           mteamName: match_data["response"]["teama"]["short_name"],
          #           mteamScore: match_data["response"]["teama"]["scores"],
          #           mteamOvers: match_data["response"]["teama"]["overs"],
          #           oteamName: match_data["response"]["teamb"]["short_name"],
          #           oteamScore: match_data["response"]["teamb"]["scores"],
          #           oteamOvers: match_data["response"]["teamb"]["overs"],
          #           result: match_data["response"]["status_note"]
          #         }
          #         # else
          #         #     puts "match not completed"
          #         # end
          #         {
          #           message: MSG_SUCCESS,
          #           status: 200,
          #           contestList: contest_list,
          #           scoreHash: score_hash
          #         }
          #       else
          #         { message: INVALID_USER, status: 500 }
          #       end
          #     rescue Exception => e
          #       logger.info "API Exception-#{Time.now}-myLiveContests-#{params.inspect}-Error-#{e}"
          #       { message: MSG_ERROR, status: 500 }
          #     end
          #   end
          # end

          # resource :userLiveMatchTeam do
          #   desc "Match List on Home API"
          #   before { api_params }

          #   params do
          #     requires :userId, type: String, allow_blank: false
          #     # requires :securityToken, type: String, allow_blank: false
          #     # requires :versionName, type: String, allow_blank: false
          #     # requires :versionCode, type: String, allow_blank: false
          #     requires :matchId, type: String, allow_blank: false
          #   end

          #   post do
          #     begin
          #       mat = Match.find(params[:matchId])
          #       require "rest-client"
          #       apiurl =
          #         "https://rest.entitysport.com/v2/matches/#{mat.mid}/live?token=3e0e77298ef32518821a2490c457300c"
          #       response = RestClient.get(apiurl, headers = { accept: :json })
          #       match_data = JSON.parse(response)
          #       # user = valid_user(params['userId'].to_i, params['securityToken'])
          #       if true
          #         team_list = []
          #         user = User.find(params["userId"].to_i)
          #         #user_teams = user.user_teams
          #         user_teams =
          #           UserTeam.where(
          #             "user_id = ? AND match_id = ?",
          #             params["userId"].to_i,
          #             params["matchId"].to_i
          #           )
          #         user_teams.each do |usr_team|
          #           role = [0, 0, 0, 0]
          #           team_count = [0, 0]
          #           total_points = 0

          #           # captain data
          #           k = Player.find_by(id: usr_team.captain_id.to_i)
          #           total_points =
          #             point_sum(k, match_data, total_points, usr_team)
          #           role = role_count(k, role)
          #           team_count = team_player_count(k, usr_team, team_count)

          #           # vcaptain data
          #           k = Player.find_by(id: usr_team.vcaptain_id.to_i)
          #           total_points =
          #             point_sum(k, match_data, total_points, usr_team)
          #           role = role_count(k, role)
          #           team_count = team_player_count(k, usr_team, team_count)

          #           # players data
          #           p = usr_team.player_ids
          #           pl = p.split(",")
          #           pl.each do |ply|
          #             k = Player.find_by(id: ply.to_i)
          #             total_points =
          #               point_sum(k, match_data, total_points, usr_team)
          #             role = role_count(k, role)
          #             team_count = team_player_count(k, usr_team, team_count)
          #             p k.id
          #           end

          #           if usr_team.total_point != total_points
          #             usr_team.update(total_point: total_points)
          #           end

          #           team_hash = {
          #             id: usr_team.id,
          #             teamName: usr_team.title,
          #             username: user.social_name,
          #             mteam_short: usr_team.match.teama_shortname,
          #             oteam_short: usr_team.match.teamb_shortname,
          #             points: usr_team.total_point,
          #             mteam_player: team_count[0],
          #             oteam_player: team_count[1],
          #             mteam_cap:
          #               (
          #                 if Player.find_by(id: usr_team.captain_id).team.abbr ==
          #                      usr_team.match.teama_shortname
          #                   true
          #                 else
          #                   false
          #                 end
          #               ),
          #             mteam_vcap:
          #               (
          #                 if Player.find_by(id: usr_team.vcaptain_id).team.abbr ==
          #                      usr_team.match.teama_shortname
          #                   true
          #                 else
          #                   false
          #                 end
          #               ),
          #             captain_name: player_name(usr_team.captain_id),
          #             vice_captain: player_name(usr_team.vcaptain_id),
          #             wkp: role[0],
          #             bat: role[1],
          #             alr: role[2],
          #             bowl: role[3]
          #           }
          #           team_list << team_hash
          #         end
          #         { message: MSG_SUCCESS, status: 200, uteamList: team_list }
          #       else
          #         { message: INVALID_USER, status: 500 }
          #       end
          #     rescue Exception => e
          #       logger.info "API Exception-#{Time.now}-userLiveMatchTeam-#{params.inspect}-Error-#{e}"
          #       { message: MSG_ERROR, status: 500 }
          #     end
          #   end
          # end

          ############################################################

        # No3
        resource :contestFilter do
          desc "Match List on Home API"
          before {api_params}

          params do
            requires :userId, type: String, allow_blank: false
            requires :securityToken, type: String, allow_blank: false
            requires :versionName, type: String, allow_blank: false
            requires :versionCode, type: String, allow_blank: false
            # requires :matchId, type: String, allow_blank: false
          end

          post do
            begin
              # user = valid_user(params['userId'].to_i, params['securityToken'])
              if true
                # filterList = []
                entryList=Filter.where(ftype: "entry").pluck(:frange)
                nteamList=Filter.where(ftype: "teams").pluck(:frange)
                prizePoolList=Filter.where(ftype: "prizepool").pluck(:frange)
                contestTypeList=Filter.where(ftype: "contesttype").pluck(:frange)

                {message: MSG_SUCCESS, status: 200, entry: entryList, teams: nteamList, prizePool: prizePoolList, contestType: contestTypeList}
              else
                {message: INVALID_USER, status: 500}
              end

            rescue Exception => e
              logger.info "API Exception-#{Time.now}-contestFilter-#{params.inspect}-Error-#{e}"
              {message: MSG_ERROR, status: 500}
            end
          end
        end

        resource :applyFilter do
          desc "Match List on Home API"
          before { api_params }

          params do
            requires :userId, type: String, allow_blank: false
            # requires :securityToken, type: String, allow_blank: false
            # requires :versionName, type: String, allow_blank: false
            # requires :versionCode, type: String, allow_blank: false
            requires :matchId, type: String, allow_blank: false
            optional :entry, type: String, allow_blank: true
            optional :teams, type: String, allow_blank: true
            optional :prizePool, type: String, allow_blank: true
            optional :contestType, type: String, allow_blank: true
          end

          post do
            begin
              user = valid_user(params["userId"].to_i, params["securityToken"])
              if user
                all_contests = []

                # Initialize filtered contest lists
                k = Contest.all
                kk = Contest.all
                kkk = Contest.all
                kkkk = Contest.all

                # Apply filters based on provided parameters
                k = apply_filters(params[:entry], "entry") if params[
                  :entry
                ].present? && !params[:entry].empty?
                kk = apply_filters(params[:teams], "teams") if params[
                  :teams
                ].present? && !params[:teams].empty?
                kkk = apply_filters(params[:prizePool], "prizePool") if params[
                  :prizePool
                ].present? && !params[:prizePool].empty?
                kkkk =
                  apply_filters(params[:contestType], "contestType") if params[
                  :contestType
                ].present? && !params[:contestType].empty?

                # Intersect filtered contest lists
                common_contests = (k & kk & kkk & kkkk)

                uteam =
                  UserTeam.where(
                    "user_id = ? AND match_id = ?",
                    params["userId"].to_i,
                    params["matchId"].to_i
                  ).size
                ucontest =
                  UserContest.where(
                    "user_id = ? AND match_id = ?",
                    params["userId"].to_i,
                    params["matchId"].to_i
                  ).size

                contest_categories = ContestCategory.active
                contest_categories.each do |contest_category|
                  act_contests =
                    common_contests.select do |contest|
                      contest.contest_category_id == contest_category.id
                    end
                  # act_contests= contest_category.common_contests
                  # act_contests = contest_category.contests.where(id: common_contests.map(&:id))

                  if act_contests.present?
                    contest_list = []
                    # contest_hash ={}
                    act_contests.each do |con|
                      contest_hash = {
                        contest_id: con.id,
                        contest_name: con.title,
                        winning_prize: con.winning_prize,
                        entry_fee: con.entry_fee,
                        total_spots: con.total_spot,
                        spots_left: "#{rand(con.total_spot.to_i)}",
                        first_prize: con.first_prize,
                        winning_percent: con.winning_percentage,
                        entry_allowed: con.entry_allowed,
                        entry_type: con.entry_type
                      }
                      contest_list << contest_hash
                    end
                    contests_hash = {
                      contestCategory: contest_category.title,
                      contest_list: contest_list
                    }
                    all_contests << contests_hash
                  end
                end
                {
                  message: MSG_SUCCESS,
                  status: 200,
                  ucontest: ucontest,
                  uteam: uteam,
                  contests: all_contests
                }
              else
                { message: INVALID_USER, status: 500 }
              end
            rescue Exception => e
              logger.info "API Exception-#{Time.now}-applyFilter-#{params.inspect}-Error-#{e}"
              { message: MSG_ERROR, status: 500 }
            end
          end
        end

        resource :leaderBoard do
          desc "Match List on Home API"
          before { api_params }

          params do
            requires :userId, type: String, allow_blank: false
            # requires :securityToken, type: String, allow_blank: false
            # requires :versionName, type: String, allow_blank: false
            # requires :versionCode, type: String, allow_blank: false
            requires :matchId, type: String, allow_blank: false
            requires :contestId, type: String, allow_blank: false
          end

          post do
            begin
              mat = Match.find_by(id: params[:matchId].to_i)
              require "rest-client"
              apiurl =
                "https://rest.entitysport.com/v2/matches/#{mat.mid}/newpoint2?token=3e0e77298ef32518821a2490c457300c"
              response = RestClient.get(apiurl, headers = { accept: :json })
              match_data = JSON.parse(response)
              # user = valid_user(params['userId'].to_i, params['securityToken'])
              if true
                user = User.find_by(id: params[:userId].to_i)
                ut =
                  UserTeam.where(
                    "match_id = ? and contest_id = ?",
                    mat.id,
                    params[:contestId].to_i
                  ).order(total_point: :desc)
                # .order(total_point: :desc)
                p = Prize.where(contest_id: params[:contestId])
                utList = []
                ut.each_with_index do |usr_team, index|
                  # if !usr_team.total_point.present?
                  total_points = 0

                  k = Player.find_by(id: usr_team.captain_id.to_i)
                  total_points =
                    point_sum(k, match_data, total_points, usr_team)

                  k = Player.find_by(id: usr_team.vcaptain_id.to_i)
                  total_points =
                    point_sum(k, match_data, total_points, usr_team)

                  p = usr_team.player_ids
                  pl = p.split(",")
                  pl.each do |ply|
                    k = Player.find_by(id: ply.to_i)
                    total_points =
                      point_sum(k, match_data, total_points, usr_team)
                  end

                  usr_team.update(total_point: total_points)
                  usert = User.find_by_id(usr_team.user_id)
                  wa =
                    Prize.find_by(
                      "contest_id = ? and rank = ?",
                      params[:contestId],
                      index + 1
                    ).amount if Prize.find_by(
                    "contest_id = ? and rank = ?",
                    params[:contestId],
                    index + 1
                  ).present?
                  # i have to find wa on rank and contest id
                  teamHash = {
                    rank: index + 1,
                    name: usert.social_name,
                    image: usert.social_imgurl,
                    points: usr_team.total_point,
                    winningAmount: wa.present? ? wa : ""
                  }
                  # else
                  #   usert=User.find_by_id(usr_team.user_id)
                  #   teamHash={
                  #     rank: index+1,
                  #     name: usert.social_name,
                  #     image: usert.social_imgurl,
                  #     points: usr_team.total_point
                  #   }
                  # end
                  utList << teamHash
                end
                # sorted_team = utList.sort_by { |hash| -hash[:points] }.each_with_index.map { |hash, index| hash.merge(rank: index+1) }

                # prizeList=[]
                # p.each do |item|
                #   prizeHash = {
                #     rank: item.rank,
                #     # userHash: utList[item.rank.to_i-1],
                #     amount: item.amount
                #   }
                #   prizeList << prizeHash
                # end

                { message: "MSG_SUCCESS", status: 200, userTeamList: utList }
              else
                { message: "INVALID_USER", status: 500 }
              end
            rescue Exception => e
              logger.info "API Exception-#{Time.now}-userMatchTeam-#{params.inspect}-Error-#{e}"
              { message: "MSG_ERROR", status: 500 }
            end
          end
        end

        resource :prizeList do
          desc "Match List on Home API"
          before { api_params }

          params do
            requires :userId, type: String, allow_blank: false
            # requires :securityToken, type: String, allow_blank: false
            # requires :versionName, type: String, allow_blank: false
            # requires :versionCode, type: String, allow_blank: false
            requires :matchId, type: String, allow_blank: false
            requires :contestId, type: String, allow_blank: false
          end

          post do
            begin
              if true
                con = Contest.find(params[:contestId].to_i)
                # if con.entry_type == "guaranteed"
                p = Prize.where(contest_id: params[:contestId].to_i)
                prizeList = []
                p.each do |item|
                  prizeHash = { rank: item.rank, amount: item.amount }
                  prizeList << prizeHash
                end
                # end
                {
                  message: MSG_SUCCESS,
                  status: 200,
                  prizePool: con.winning_prize,
                  totalSpots: con.total_spot,
                  entryAmount: con.entry_fee,
                  winningHash: prizeList
                }
              else
                { message: INVALID_USER, status: 500 }
              end
            rescue Exception => e
              logger.info "API Exception-#{Time.now}-userMatchTeam-#{params.inspect}-Error-#{e}"
              { message: MSG_ERROR, status: 500 }
            end
          end
        end
      end
    end
  end
end
