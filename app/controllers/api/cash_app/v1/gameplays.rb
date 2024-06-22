module API
  module CashApp
    module V1
      class Gameplays < Grape::API
        include API::CashApp::V1::Defaults

        # completed=1
        # incomplete=2
        # pending=3

        HEXCLR = ['#8E44AD','#E53935','#F1C40F','#E74C3C','#239B56']

        UPIC = ['https://lh3.googleusercontent.com/a/AEdFxTp6TjUur5qgWhe5AQS6RqRjFvW_iAT4LYdumhgBW1Q=s96-c',
          'https://lh3.googleusercontent.com/a/AEdFTp5yGRjDSVCAUDRoMsLsGc0hw_B5IVlKXP2DnVdV5g=s96-c',
          'https://lh3.googleusercontent.com/a/AEdFTp7IF_HAhnlvmubAe-ywy8eJGgfeJyS1wpf9pQBIRw=s96-c',
          'https://lh3.googleusercontent.com/a/AEdFTp6Y9nZccAII1C_KvPggY_OzexoAy9f6pRoKiI0-=s96-c',
          'https://lh3.googleusercontent.com/a/AEdFTp7UJHXC47B4F7GWWhvwjjhHyvtvOvok2tdvjDF18A=s96-c',
          'https://lh3.googleusercontent.com/a/AEdFTp6ekCsBpPB7HzU_pdHfGF1-EKY6PpgHbIETclGT=s96-c']

        ##################################################################
        # => V1 Home Page Match List Api
        ##################################################################
        resource :userCreateTeam do
          desc "Match List on Home API"
          before {api_params}

          params do
            requires :userId, type: String, allow_blank: false
            requires :securityToken, type: String, allow_blank: false
            requires :versionName, type: String, allow_blank: false
            requires :versionCode, type: String, allow_blank: false
            optional :contestId, type: String, allow_blank: false
            requires :matchId, type: String, allow_blank: false
            requires :captain, type: String, allow_blank: false
            requires :viceCaptain, type: String, allow_blank: false
            requires :selectedPlayers, type: String, allow_blank: false
          end

          post do
            begin
              # user = valid_user(params['userId'].to_i, params['securityToken'])
              items_array = params[:selectedPlayers].split(',')

              # Remove the specified item from the array
              items_array.delete(params[:captain])
              items_array.delete(params[:viceCaptain])

              # Join the modified array back into a string
              updated_string = items_array.join(',')

              # Remove the trailing comma if needed
              updated_string.chomp!(',')

              if true
                # if params[:contestId] && !params[:contestId].empty?
                #   contest_rec = Contest.find(params[:contestId].to_i)
                #   usr_team = UserTeam.create(gtype: 'cricket', title: "TEAM#{rand(99)}", user_id: params[:userId].to_i,
                #   mstatus: Match.find_by_id(params[:matchId].to_i).mstatus, captain_id: params[:captain].to_i, vcaptain_id: params[:viceCaptain].to_i,
                #   player_ids: updated_string, contest_id: params[:contestId].to_i, match_id: params[:matchId].to_i)
                #   usr_contest = UserContest.create(gtype: 'cricket', title: contest_rec.title, rank: rand(99), contest_id: params[:contestId].to_i,
                #   vcaptain_name: player_name(params[:captain].to_i), captain_name: player_name(params[:viceCaptain].to_i), user_id: params[:userId].to_i,
                #   winning_prize: contest_rec.winning_prize, total_spot: contest_rec.total_spot, entry_fee: contest_rec.entry_fee, user_team_id: usr_team.id,
                #   entry_type: 'paid', entry_allowed: contest_rec.entry_allowed, totalscore: '00', match_id: params[:matchId].to_i, mstatus: Match.find_by_id(params[:matchId].to_i).mstatus)
                # else
                  usr_team = UserTeam.create(gtype: 'cricket', title: "TEAM#{rand(99)}", user_id: params[:userId].to_i, mstatus: Match.find_by_id(params[:matchId].to_i).mstatus,
                   captain_id: params[:captain].to_i, vcaptain_id: params[:viceCaptain].to_i, player_ids: updated_string, match_id: params[:matchId].to_i, contest_id: params[:contestId].to_i)
                # end

                role=[0,0,0,0]
                k=Player.find_by(id: usr_team.captain_id.to_i)
                role=role_count(k,role)

                k=Player.find_by(id: usr_team.vcaptain_id.to_i)
                role=role_count(k,role)

                p=usr_team.player_ids
                pl=p.split(",")
                pl.each do |ply|
                  k=Player.find_by(id: ply.to_i)
                  role=role_count(k,role)
                  # team_count=team_player_count(k,usr_team,team_count)
                end

                team_hash = {
                  userTeamId: usr_team.id,
                  username: User.find_by(id: usr_team.user_id).social_name,
                  mteam_short: usr_team.match.teama_shortname,
                  oteam_short: usr_team.match.teamb_shortname,
                  mteam_cap: Player.find_by(id: usr_team.captain_id).team.abbr == usr_team.match.teama_shortname ? true : false,
                  mteam_vcap: Player.find_by(id: usr_team.vcaptain_id).team.abbr == usr_team.match.teama_shortname ? true : false,
                  captain_name: player_name(usr_team.captain_id),
                  vice_captain: player_name(usr_team.vcaptain_id),
                  wkp: role[0],
                  bat: role[1],
                  alr: role[2],
                  bowl: role[3]
                }

                {message: MSG_SUCCESS, status: 200, teamHash: team_hash}
              else
                {message: INVALID_USER, status: 500}
              end

            rescue Exception => e
              logger.info "API Exception-#{Time.now}-userCreateTeam-#{params.inspect}-Error-#{e}"
              {message: MSG_ERROR, status: 500}
            end
          end
        end

        resource :joinContest do
          desc "Match List on Home API"
          before {api_params}

          params do
            requires :userId, type: String, allow_blank: false
            requires :securityToken, type: String, allow_blank: false
            requires :versionName, type: String, allow_blank: false
            requires :versionCode, type: String, allow_blank: false
            requires :contestId, type: String, allow_blank: true
            requires :userTeamId, type: String, allow_blank: true

          end

          post do
            begin
              # user = valid_user(params['userId'].to_i, params['securityToken'])
              user=User.find(params[:userId])
              user_team = UserTeam.find(params[:userTeamId])
              # user_profile = User.find(params[:userId])
              # if user_profile.present?
                # user_kyc_status = user_profile.is_kyc_completed ? "complete" : "pending"
              # else
                # user_kyc_status = 'pending'
                # user_profile = User.new(id: params[:userId].to_i, name: user.social_name, email: user.social_email, mobile_number: user.mobile_number,
                #   dob: Date.current, gender: 'Male', country: 'India', state: 'New Delhi', city: 'Delhi', pincode: '110040',
                #   address: 'H.No-#001', kyc_status: 'pending')
                # user_profile.save!
              # end
              if user
                  # user_kyc_status = ['pending','completed'].sample
                  contest_rec = Contest.find(params[:contestId])
                  # if user_team.contest_id == params[:contestId].to_i
                    # msg = "Contest already joined with this team"
                    # join_status = false
                  # else
                user_kyc_status = user.is_kyc_completed ? "complete" : "pending"

                    if user_kyc_status == "complete"
                      usr_team = user_team.update(contest_id: params[:contestId])
                      usr_contest = UserContest.create(
                        gtype: 'cricket',
                         title: contest_rec.title,
                         contest_id: params[:contestId],
                        winning_prize: contest_rec.winning_prize,
                         total_spot: contest_rec.total_spot,
                          entry_fee: contest_rec.entry_fee,
                        entry_allowed: contest_rec.entry_allowed,
                         rank: rand(99),
                          captain_name: player_name(user_team.captain_id.to_i),
                           vcaptain_name: player_name(user_team.vcaptain_id.to_i),
                            user_id: params[:userId].to_i,
                        user_team_id: user_team.id,
                         entry_type: 'paid',
                          totalscore: '00',
                           match_id: user_team.match_id,
                            mstatus: Match.find_by_id(user_team.match_id.to_i).mstatus)
                      msg = "Contest joined successfully"
                      # join_status= true
                      # kyc_status= 1
                    else
                      # kyc_status = user_kyc_status == "pending" ? 3 : 2
                      msg = "Contest not joined, due to kyc pending"
                      # join_status = false
                    # end
                  end

                {
                  message: MSG_SUCCESS,
                   status: 200,
                    msg: msg,
                #  join_status: join_status,
                  # kyc_status: kyc_status
                }
              else
                {message: INVALID_USER, status: 500}
              end

            rescue Exception => e
              logger.info "API Exception-#{Time.now}-joinContest-#{params.inspect}-Error-#{e}"
              {message: MSG_ERROR, status: 500,error:e}
            end
          end
        end

        ##################################################################
        # => V1 Home Page Match List Api
        ##################################################################
        resource :userProfile do
          desc "Match List on Home API"
          before {api_params}

          params do
            requires :userId, type: String, allow_blank: false
            requires :securityToken, type: String, allow_blank: false
            requires :versionName, type: String, allow_blank: false
            requires :versionCode, type: String, allow_blank: false
          end

          post do
            begin
              user = valid_user(params['userId'].to_i, params['securityToken'])
              if user
                contests_count = UserContest.where(user_id:params[:userId]).count
                matches_count = UserTeam.where(user_id:params[:userId]).count
                {message: MSG_SUCCESS,
                 status: 200,
                  user_id: user.id,
                   image_url: user.social_imgurl,
                    kscore:[225,125,150].sample,
                  username: user.social_name,
                  #  follower: [11,22,33,44].sample,
                    # following: [11,22,33,44].sample,
                    #  friends: [225,125,150].sample,
                  contest: contests_count,
                  matches: matches_count,
                   series: [11,22,33,44].sample,
                    sport: [11,22,33,44].sample
                  }
              else
                {message: INVALID_USER, status: 500}
              end

            rescue Exception => e
              logger.info "API Exception-#{Time.now}-userProfile-#{params.inspect}-Error-#{e}"
              {message: MSG_ERROR, status: 500}
            end
          end
        end

        resource :userImageUpdate do
          desc "Match List on Home API"
          before {api_params}

          params do
            requires :userId, type: String, allow_blank: false
            # requires :securityToken, type: String, allow_blank: false
            # requires :versionName, type: String, allow_blank: false
            # requires :versionCode, type: String, allow_blank: false
          end

          post do
            begin
              user = valid_user(params['userId'].to_i, params['securityToken'])
              if user
                photo_data = params[:photo]
                filename = photo_data[:filename]
                user.update(social_imgurl: filename)
                {message: MSG_SUCCESS, status: 200, msg: "Your profile image is updated"}
              else
                {message: INVALID_USER, status: 500}
              end

            rescue Exception => e
              logger.info "API Exception-#{Time.now}-userImageUpdate-#{params.inspect}-Error-#{e}"
              {message: MSG_ERROR, status: 500}
            end
          end
        end

        ##################################################################
        # => V1 Home Page Match List Api    updated by aditya singh
        ##################################################################
        resource :userProfileKyc do
          desc "Match List on Home API"
          before {api_params}

          params do
            requires :userId, type: String, allow_blank: false
            requires :securityToken, type: String, allow_blank: false
            requires :versionName, type: String, allow_blank: false
            requires :versionCode, type: String, allow_blank: false
            #requires :contestId, type: String, allow_blank: false
          end

          post do
            begin
              user = valid_user(params['userId'].to_i, params['securityToken'])
              if user
                user_id = params[:userId]
                name = params[:name]
                pan_number = params[:panNumber]
                dob = params[:dob]

                # Access the 'photo' field which contains the multipart data
                photo_data = params[:photo]
                filename = photo_data[:filename]

                # Save the data to the database
                kycdetails = Kycdetail.create(user_id: user_id.to_i, name: name, pan_number: pan_number, dob: dob, photo_data: filename)
                user.update(is_kyc_completed: true)
                {message: MSG_SUCCESS, status: 200, kycDetails: kycdetails, msg: "KYC submitted succesffuly",verificationStatus: "complete"}
              else
                {message: INVALID_USER, status: 500}
              end

            rescue Exception => e
              logger.info "API Exception-#{Time.now}-userProfileKyc-#{params.inspect}-Error-#{e}"
              {message: MSG_ERROR, status: 500}
            end
          end
        end


        ##################################################################
        # => V1 Home Page Match List Api    created by aditya singh
        ##################################################################

        resource :userComplaint do
          desc "Complaint List on Home API"
          before {api_params}

          params do
            requires :userId, type: String, allow_blank: false
            requires :securityToken, type: String, allow_blank: false
            requires :versionName, type: String, allow_blank: false
            requires :versionCode, type: String, allow_blank: false
            requires :title, type: String, allow_blank: false
            requires :description, type: String, allow_blank: false
            requires :description, type: String, allow_blank: false
            requires :photo, type: Hash, allow_blank: false
          end

          post do
            begin
              user = valid_user(params['userId'].to_i, params['securityToken'])
              if user
                user_id = params[:userId]
                title = params[:title]
                description = params[:description]

                # Access the 'photo' field which contains the multipart data
                photo_data = params[:photo]
                filename = photo_data[:filename]

                # Save the data to the database
                complaintdetails = Complaint.create(user_id: user_id.to_i, title: title, description: description, image: filename)

                {message: MSG_SUCCESS, status: 200, user_message: "Complaint submitted successfully"}
              else
                {message: INVALID_USER, status: 500}
              end

            rescue Exception => e
              logger.info "API Exception-#{Time.now}-userComplaint-#{params.inspect}-Error-#{e}"
              {message: MSG_ERROR, status: 500}
            end
          end
        end

        ##################################################################
        # => V1 userProfile
        ##################################################################
        # resource :updateProfile do
        #   desc "App User Profile API"
        #   before {api_params}

        #   params do
        #     requires :userId, type: String, allow_blank: false
        #     requires :securityToken, type: String, allow_blank: false
        #     requires :versionName, type: String, allow_blank: false
        #     requires :versionCode, type: String, allow_blank: false
        #     optional :actionType, type: String, allow_blank: false #(get/post)
        #   end

        #   post do
        #     begin
        #       user = valid_user(params['userId'].to_i, params['securityToken'])
        #       if user
        #         source_ip = env['REMOTE_ADDR'] || env['HTTP_X_FORWARDED_FOR']
        #         if params['actionType'] == 'post'
        #           # user_profile = UserProfile.where(user_id: user.id).first_or_initialize
        #           # if user_profile.new_record?
        #           #   user_profile.update(full_name: params['userName'], user_email: params['userEmail'], mobile_number: params['mobileNumber'],
        #           #     gender: params['gender'], location: params['location'], occupation: params['occupation'], source_ip: source_ip,
        #           #     birth_date: params['birthDate'], profile_pic: params['mobileNumber'], paid: true, status: true)
        #           # else
        #           #   user_profile.update(full_name: params['userName'], user_email: params['userEmail'], mobile_number: params['mobileNumber'],
        #           #     gender: params['gender'], location: params['location'], occupation: params['occupation'], birth_date: params['birthDate'])
        #           # end
        #           {message: MSG_SUCCESS, status: 200, msg: 'User Profile Submitted.'}
        #         else
        #           user_profile = false #UserProfile.where(user_id: user.id).first
        #           if user_profile
        #             {message: MSG_SUCCESS, status: 200, userName: user_profile.full_name, userEmail: user_profile.user_email, mobileNumber: user_profile.mobile_number,
        #               gender: user_profile.gender, location: user_profile.location, occupation: user_profile.occupation, birthDate: user_profile.birth_date,
        #               socialImgurl: user.social_imgurl}
        #           else
        #             {message: MSG_SUCCESS, status: 200, userName: user.social_name, userEmail: user.social_email, mobileNumber: '',
        #               gender: '', country: '', state: '', city: '', address: '', pinCode: '', birthDate: '', socialImgurl: user.social_imgurl, msg: 'ok'}
        #           end
        #         end
        #       else
        #        {message: INVALID_USER, status: 500}
        #       end

        #     rescue Exception => e
        #       logger.info "API Exception-#{Time.now}-updateProfile-#{params.inspect}-Error-#{e}"
        #       {message: MSG_ERROR, status: 500}
        #     end
        #   end
        # end

        resources :updateProfile do
          desc "User Sign In API"
          before { api_params }

          params do
            requires :userId, type: String, allow_blank: false
            requires :securityToken, type: String, allow_blank: true
            requires :versionName, type: String, allow_blank: false
            requires :versionCode, type: String, allow_blank: false
            optional :actionType, type: String, allow_blank: false # (get/post)
            optional :mobileNumber, type: String, allow_blank: true
            optional :birthDate, type: String, allow_blank: true
            optional :gender, type: String, allow_blank: true
            optional :state, type: String, allow_blank: true
            optional :city, type: String, allow_blank: true
            optional :pinCode, type: String, allow_blank: true
          end

          post do
            begin
              user = valid_user(params[:userId], params[:securityToken])
              if !user
                { status: 500, message: "User Not Found" }
              else
                if params[:actionType] == "get"
                  {
                    status: 200, message: "Success",
                    userName: user.social_name,
                    userEmail: user.social_email,
                    mobileNumber: user.mobile_number,
                    birthDate: user.dob,
                    gender: user.gender,
                    state: user.state,
                    city: user.city,
                    pinCode: user.pincode
                  }
                else
                  user.update(
                    mobile_number: params[:mobileNumber],
                    gender: params[:gender],
                    dob: params[:birthDate],
                    state: params[:state],
                    city: params[:city],
                    pincode: params[:pinCode]
                  )
                  { status: 200, message: MSG_SUCCESS }
                end
              end
            rescue Exception => e
              logger.info "API Exception - #{Time.now} - updateProfile - #{params.inspect} - Error - #{e}"
              { message: MSG_ERROR, status: 500 }
            end
          end
        end

        ##################################################################
        # => V1 Home Page Match List Api
        ##################################################################
        resource :addBalance do
          desc "Match List on Home API"
          before {api_params}

          params do
            requires :userId, type: String, allow_blank: false
            requires :securityToken, type: String, allow_blank: false
            requires :versionName, type: String, allow_blank: false
            requires :versionCode, type: String, allow_blank: false
            requires :addBalance, type: String, allow_blank: false
          end

          post do
            begin
              user = valid_user(params['userId'].to_i, params['securityToken'])
              if user
               user.update(wallet_balance:params[:addBalance])
               {message: MSG_SUCCESS, status:200}
              else
                {message: INVALID_USER, status: 500}
              end

            rescue Exception => e
              logger.info "API Exception-#{Time.now}-userBalance-#{params.inspect}-Error-#{e}"
              {message: MSG_ERROR, status: 500}
            end
          end
        end


        ##################################################################
        # => V1 Home Page Match List Api
        ##################################################################
        resource :userBalance do
          desc "Match List on Home API"
          before {api_params}

          params do
            requires :userId, type: String, allow_blank: false
            # requires :securityToken, type: String, allow_blank: false
            # requires :versionName, type: String, allow_blank: false
            # requires :versionCode, type: String, allow_blank: false
            #requires :contestId, type: String, allow_blank: false
          end

          post do
            begin
              user = valid_user(params['userId'].to_i, params['securityToken'])
              if user
                {message: MSG_SUCCESS, status: 200, total_balance: user.wallet_balance, add_amount: [110,220,330,440].sample,
                 winning_amount:[225,125,150].sample, cash_bonus: [50,75,35,45].sample}
              else
                {message: INVALID_USER, status: 500}
              end

            rescue Exception => e
              logger.info "API Exception-#{Time.now}-userBalance-#{params.inspect}-Error-#{e}"
              {message: MSG_ERROR, status: 500}
            end
          end
        end

        resource :userMatchData do
          desc "Match List on Home API"
          before {api_params}

          params do
            requires :userId, type: String, allow_blank: false
            # requires :securityToken, type: String, allow_blank: false
            # requires :versionName, type: String, allow_blank: false
            # requires :versionCode, type: String, allow_blank: false
            requires :mType, type: String, allow_blank: false
          end

          post do
            begin
              user = valid_user(params['userId'].to_i, params['securityToken'])
              if user
              match_list = []

              #current_datetime = DateTime.now
              current_datetime = Time.zone.now
              formatted_current_datetime = current_datetime.strftime('%Y-%m-%d %H:%M:%S')
              if params[:mType] == "1"
               user_team = UserTeam.where(user_id: params['userId'].to_i).joins(:match).where('date_start_ist > ?', formatted_current_datetime).order(date_start_ist: :asc).limit(20).group(:match_id)
              else
               user_team = UserTeam.where(user_id: params['userId'].to_i).joins(:match).order(date_start_ist: :desc).limit(20).group(:match_id)
              end

              user_team.each do |usr_team|
                record = Match.find_by(id: usr_team.match_id)
                if record.date_start_ist < formatted_current_datetime && record.date_end_ist > formatted_current_datetime
                  record.update(mstatus: "3",mstatus_str: "Live")
                  usr_team.update(mstatus: "3")
                elsif record.date_end_ist < formatted_current_datetime
                  record.update(mstatus: "2",mstatus_str: "Completed")
                  usr_team.update(mstatus: "2")
                end
                if record.mstatus.to_i == params[:mType].to_i
                # matches.each do |record|
                    front_team = {team_id: record.teama_id, team_title: record.teama_name, short_name: record.teama_shortname, team_color: HEXCLR.sample, team_logo: record.teama_logourl}
                    opp_team = {team_id: record.teamb_id, team_title: record.teamb_name, short_name: record.teamb_shortname, team_color: HEXCLR.sample, team_logo: record.teamb_logourl}
                    match_hash = {
                      match_id: record.id,
                      match_title: record.title,
                      match_status: record.status,
                      contestCount: UserTeam.where(user_id: params[:userId], match_id: usr_team.match_id).group(:contest_id).count.keys.count,
                      teamCount: UserTeam.where(user_id: params[:userId], match_id: usr_team.match_id).count,
                      match_time: record.date_start_ist,
                      front_team: front_team,
                      opp_team: opp_team
                    }
                    # .to_datetime.strftime("%Y-%m-%d %l:%M:%S")
                    match_list << match_hash
                # end
                end
              end
                {message: MSG_SUCCESS, status: 200, matchList: match_list}
              else
                {message: INVALID_USER, status: 500}
              end

            rescue Exception => e
              logger.info "API Exception-#{Time.now}-userMatchData-#{params.inspect}-Error-#{e}"
              {message: MSG_ERROR, status: 500}
            end
          end
        end








        resource :userTeamPreview do
          desc "Match List on Home API"
          before {api_params}

          params do
            requires :userId, type: String, allow_blank: false
            # requires :securityToken, type: String, allow_blank: false
            # requires :versionName, type: String, allow_blank: false
            # requires :versionCode, type: String, allow_blank: false
            requires :matchId, type: String, allow_blank: false
            requires :userTeamId, type: String, allow_blank: false
          end

          post do
            begin

              mat = Match.find(params[:matchId])
              require 'rest-client'
              apiurl = "https://rest.entitysport.com/v2/matches/#{mat.mid}/newpoint2?token=3e0e77298ef32518821a2490c457300c"
              response = RestClient.get(apiurl, headers={accept: :json})
              match_data = JSON.parse(response)
              # user = valid_user(params['userId'].to_i, params['securityToken'])
              if true
                player_list = []
                usr_team = UserTeam.find_by(id: params[:userTeamId])
                total_credits=0
                 if mat.mstatus_str == "Completed" || mat.mstatus_str == "Live"

                    captain=Player.find_by(id: usr_team.captain_id)
                    t=Team.find_by_id(captain.team_id)
                    if t.tid.to_i == match_data["response"]["teama"]["team_id"]
                      cap=playerhash(match_data,captain,t,usr_team,"teama","Completed")
                    else
                      cap=playerhash(match_data,captain,t,usr_team,"teamb","Completed")
                    end

                    total_credits= total_credits + captain.fantasy_player_rating.to_i
                    player_list << cap

                    vc_captain=Player.find_by(id: usr_team.vcaptain_id)
                    t=Team.find_by_id(vc_captain.team_id)
                    if t.tid.to_i == match_data["response"]["teama"]["team_id"]
                      vcap=playerhash(match_data,vc_captain,t,usr_team,"teama","Completed")
                    else
                      vcap=playerhash(match_data,vc_captain,t,usr_team,"teamb","Completed")
                    end

                    total_credits= total_credits + vc_captain.fantasy_player_rating.to_i
                    player_list << vcap

                    p=usr_team.player_ids
                    pl=p.split(",")
                    bat=bowl=all=wk=a=b=0

                    pl.each do |ply|
                      k=Player.find_by(id: ply.to_i)
                      t=Team.find_by_id(k.team_id)
                        if t.tid.to_i == match_data["response"]["teama"]["team_id"]
                          player_list << playerhash(match_data,k,t,usr_team,"teama","Completed")
                        else
                          player_list << playerhash(match_data,k,t,usr_team,"teamb","Completed")
                        end
                      total_credits= total_credits + k.fantasy_player_rating.to_i
                    end

                  elsif mat.mstatus_str == "Scheduled"

                      captain=Player.find_by(id: usr_team.captain_id)
                      t=Team.find_by_id(captain.team_id)

                      cap=playerhash(match_data,captain,t,usr_team,"teamb","Scheduled")

                      total_credits= total_credits + captain.fantasy_player_rating.to_i
                      player_list << cap

                      vc_captain=Player.find_by(id: usr_team.vcaptain_id)
                      t=Team.find_by_id(vc_captain.team_id)
                      vcap=playerhash(match_data,vc_captain,t,usr_team,"teamb","Scheduled")

                      total_credits= total_credits + vc_captain.fantasy_player_rating.to_i
                      player_list << vcap

                      p=usr_team.player_ids
                      pl=p.split(",")

                        pl.each do |ply|
                        k=Player.find_by(id: ply.to_i)
                        t=Team.find_by_id(k.team_id)
                          player_list << playerhash(match_data,k,t,usr_team,"teamb","Scheduled")
                          total_credits = total_credits + k.fantasy_player_rating.to_i
                        end

                end

                role_priorities = {
                  0 => 1,
                  1 => 2,
                  2 => 3,
                  3 => 4
                }

                player_list.sort_by! { |player| [role_priorities[player[:playerRole]], player[:playerName]] }

                {message: MSG_SUCCESS, status: 200,captainId: usr_team.captain_id.to_i, viceCaptainId: usr_team.vcaptain_id.to_i,totalCredits: "#{100-total_credits.to_i}", playerList: player_list}
              else
                {message: INVALID_USER, status: 500}
              end

            rescue Exception => e
              logger.info "API Exception-#{Time.now}-userTeamPreview-#{params.inspect}-Error-#{e}"
              {message: MSG_ERROR, status: 500}
            end
          end
        end

        resource :matchScoreData do
          desc "Match Score Data API"
          before {api_params}

          params do
            requires :userId, type: String, allow_blank: false
            # requires :securityToken, type: String, allow_blank: false
            # requires :versionName, type: String, allow_blank: false
            # requires :versionCode, type: String, allow_blank: false
            requires :matchId, type: String, allow_blank: false
          end

          post do
            begin
              user = valid_user(params['userId'].to_i, params['securityToken'])
              if user
                score_card = ScoreCard.find_by_match_id(params[:matchId])
                if score_card.present?
                  match_data = JSON.parse(score_card.match_data)
                else
                  matchrc = Match.find(params[:matchId])
                  require 'rest-client'
                  apiurl = "https://rest.entitysport.com/v2/matches/#{matchrc.mid}/scorecard?token=#{TOKEN.sample}"
                  response = RestClient.get(apiurl, headers={accept: :json})
                  puts response
                  match_data = JSON.parse(response)
                  puts match_data
                  score_card = ScoreCard.create(mid: matchrc.mid, match_id: matchrc.id, match_data: response)
                end
                {message: MSG_SUCCESS, status: 200, innings: match_data["response"]["innings"]}
              else
                {message: INVALID_USER, status: 500}
              end
            rescue Exception => e
              logger.info "API Exception-#{Time.now}-matchScoreData-#{params.inspect}-Error-#{e}"
              {message: MSG_ERROR, status: 500}
            end
          end
        end


        resource :playerScoreData do
          desc "Match Score Data API"
          before {api_params}

          params do
            requires :userId, type: String, allow_blank: false
            # requires :securityToken, type: String, allow_blank: false
            # requires :versionName, type: String, allow_blank: false
            # requires :versionCode, type: String, allow_blank: false
            requires :matchId, type: String, allow_blank: false
            requires :playerId, type: String, allow_blank: false
          end

          post do
            begin
              user = valid_user(params['userId'].to_i, params['securityToken'])
              if user
                  mat = Match.find(params[:matchId])
                  require 'rest-client'
                  apiurl = "https://rest.entitysport.com/v2/matches/#{mat.mid}/newpoint2?token=#{TOKEN.sample}"

                  response = RestClient.get(apiurl, headers={accept: :json})
                  match_data = JSON.parse(response)

                  p = Player.find_by_id(params[:playerId])
                  team=Team.find_by_id(p.team_id)

                  playerInfo={}

                  # checking if the player is from teama or team b
                  if team.tid.to_i == match_data["response"]["teama"]["team_id"]
                    playerInfo=player_list(match_data,"teama",p,team)
                  else
                    playerInfo=player_list(match_data,"teamb",p,team)
                  end

                  # mat_data=match_data["points"]["teama"]
                {message: MSG_SUCCESS, status: 200, playerInfo: playerInfo}
              else
                {message: INVALID_USER, status: 500}
              end

            rescue Exception => e
              logger.info "API Exception-#{Time.now}-playerScoreData-#{params.inspect}-Error-#{e}"
              {message: MSG_ERROR, status: 500}
            end
          end
        end

      end
    end
  end

end
