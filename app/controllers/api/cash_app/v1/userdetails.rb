module API
  module CashApp
    module V1
      class Userdetails < Grape::API
        include API::CashApp::V1::Defaults
        # version 'v1', using: :path
        # format :json
        # prefix :api

        ##################################################################
        # => V1 user Sign In Api
        ##################################################################
        resource :userSignin do
          desc "User Sign In API"
          before {api_params}

          params do
            requires :deviceId, type: String, allow_blank: false
            optional :deviceType, type: String, allow_blank: true
            optional :deviceName, type: String, allow_blank: true

            requires :socialType, type: String, allow_blank: false
            requires :socialId, type: String, allow_blank: false
            optional :socialToken, type: String, allow_blank: false

            optional :socialEmail, type: String, allow_blank: true
            optional :socialName, type: String, allow_blank: true
            optional :socialImgurl, type: String, allow_blank: true

            optional :advertisingId, type: String, allow_blank: true
            requires :versionName, type: String, allow_blank: false
            requires :versionCode, type: String, allow_blank: false

            optional :utmSource, type: String, allow_blank: true
            optional :utmMedium, type: String, allow_blank: true
            optional :utmTerm, type: String, allow_blank: true
            optional :utmContent, type: String, allow_blank: true
            optional :utmCampaign, type: String, allow_blank: true
          end

          post do
            begin
              source_ip = env['REMOTE_ADDR'] || env['HTTP_X_FORWARDED_FOR']
              location_ip = env['HTTP_X_FORWARDED_FOR'] || env['REMOTE_ADDR']

              genuine_user = true #google_validator(params['socialToken'], params['socialEmail'])
              if genuine_user == false
                logger.info "API Exception-BLOCK-GLV:#{Time.now}-userSignin-#{params.inspect}"
                {message: GBLOCKED, status: 500}
              else
                source_ip_count = User.where(source_ip: source_ip).count
                location_ip_count = User.where(location: location_ip).count

                if source_ip_count > MAX_IP_COUNT
                  logger.info "API Exception-BLOCK-IPS:#{Time.now}-userSignin-#{params.inspect}"
                  {message: BLOCKED, status: 500}
                elsif location_ip_count > MAX_IP_COUNT
                  logger.info "API Exception-BLOCK-IPL:#{Time.now}-userSignin-#{params.inspect}"
                  {message: BLOCKED, status: 500}
                else
                  user = User.where(social_id: params['socialId']).first_or_initialize
                  refCode = SecureRandom.hex(4).upcase
                  utm_medium = params['utmMedium']

                  if user.new_record?
                    user.update(referral_code: refCode, social_email: params['socialEmail'], social_type: params['socialType'],
                     social_name: params['socialName'], social_imgurl: params['socialImgurl'], device_type: params['deviceType'],
                     device_name: params['deviceName'], advertising_id: params['advertisingId'], version_name: params['versionName'],
                     version_code: params['versionCode'], security_token: SecureRandom.uuid, fcm_token: params['fcmToken'], social_token: params['referrerUrl'],
                     device_id: params['deviceId'], location: location_ip, source_ip: source_ip, utm_source: params['utmSource'], utm_medium: utm_medium)
                    #Only New User Bonus
                    #Transaction.create(user_id: user.id, trans_name: 'SignUp Bonus', trans_type: 'SIGNUP', trans_amount: INVITE_AMT)
                    #Account.create(user_id: user.id, coin_balance: INVITE_COIN, amount_balance: INVITE_AMT)
                  else
                    user.update(social_email: params['socialEmail'], social_type: params['socialType'], utm_medium: params['utmMedium'],
                     social_name: params['socialName'], social_imgurl: params['socialImgurl'], device_type: params['deviceType'],
                     device_name: params['deviceName'], advertising_id: params['advertisingId'], version_name: params['versionName'],
                     version_code: params['versionCode'], fcm_token: params['fcmToken'], social_token: params['referrerUrl'],
                     device_id: params['deviceId'], location: location_ip, source_ip: source_ip, utm_source: params['utmSource'])
                  end
                  {status: 200, message: MSG_SUCCESS, userId: user.id, securityToken: user.security_token}
                end
              end

            rescue Exception => e
              logger.info "API Exception-#{Time.now}-userSignin-#{params.inspect}-Error-#{e}"
              {message: MSG_ERROR, status: 500}
            end
          end
        end

        ##################################################################
        # => V1 user Sign Up Api
        ##################################################################
        resource :userSignup do
          desc "User Sign Up API"
          before {api_params}

          params do
            requires :deviceId, type: String, allow_blank: false
            optional :deviceType, type: String, allow_blank: true
            optional :deviceName, type: String, allow_blank: true

            requires :socialType, type: String, allow_blank: false
            requires :socialId, type: String, allow_blank: false
            optional :socialToken, type: String, allow_blank: false

            optional :socialEmail, type: String, allow_blank: true
            optional :socialName, type: String, allow_blank: true
            optional :socialImgurl, type: String, allow_blank: true

            optional :advertisingId, type: String, allow_blank: true
            requires :versionName, type: String, allow_blank: false
            requires :versionCode, type: String, allow_blank: false

            optional :utmSource, type: String, allow_blank: true
            optional :utmMedium, type: String, allow_blank: true
            optional :utmTerm, type: String, allow_blank: true
            optional :utmContent, type: String, allow_blank: true
            optional :utmCampaign, type: String, allow_blank: true
          end

          post do
            begin
              source_ip = env['REMOTE_ADDR'] || env['HTTP_X_FORWARDED_FOR']
              location_ip = env['HTTP_X_FORWARDED_FOR'] || env['REMOTE_ADDR']

              genuine_user = true#google_validator(params['socialToken'], params['socialEmail'])
              if genuine_user == false
                logger.info "API Exception-BLOCK-GLV:#{Time.now}-userSignup-#{params.inspect}"
                {message: GBLOCKED, status: 500}
              else
                {status: 200, message: MSG_SUCCESS, userId: '1', securityToken: '32124-da55235-3211gfH-H45df99n', socialImgurl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&q=80'}
              end
            rescue Exception => e
              logger.info "API Exception-#{Time.now}-userSignup-#{params.inspect}-Error-#{e}"
              {message: MSG_ERROR, status: 500}
            end
          end
        end


        ##################################################################
        # => V1 user app open api
        ##################################################################
        resource :appOpen do
          desc "App Open API"
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
                force_update = false
                {message: MSG_SUCCESS, status: 200, forceUpdate: force_update, paycoinLimit: 5000, userCoin: '37000', userAmount: '370', currency: '₹', packAge: 'com.kismapp.android',kycStatus:user.is_kyc_completed ? "complete" : "pending"}
              else
                {message: INVALID_USER, status: 500}
              end

            rescue Exception => e
              logger.info "API Exception-#{Time.now}-appOpen-#{params.inspect}-Error-#{e}"
              {message: MSG_ERROR, status: 500,error:e}
            end
          end
        end



        ##################################################################
        # => V1 Invite Page
        ##################################################################
        resource :appInvite do
          desc "Invite Page API"
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
                inviteText = "Get 500 rewards points for you and your friends!"
                inviteFbUrl = "https://statussavvy.app/invite/#{user.referral_code}/?by=facebook"
                inviteImgurl = "https://braveryportal.com/wp-content/uploads/2021/06/Paypal-Referal-1024x576.png"
                inviteTextUrl = "Download StatusSavvy App and get free Paytm/Paypal Cashback upto Rs.500, Click here: https://statussavvy.app/invite/#{user.referral_code}/?by=social"
                howitwork = ["Share, Invite Friends and Earn StatusSavvy points.", "Get 500 StatusSavvy points instant as your Friend Register on StatusSavvy App.", "Get a Chance to Earn upto 5,000 StatusSavvy points for Top Inviters.",
                 "Sponsorship for YouTube, WhatsApp, Telegram and Facebook Content Creator Available!"]
                {message: MSG_SUCCESS, status: 200, referralCode: user.referral_code, inviteFbUrl: inviteFbUrl, inviteTextUrl: inviteTextUrl, inviteImgurl: inviteImgurl, inviteText: inviteText, howitWork: howitwork}
              else
                {message: INVALID_USER, status: 500}
              end

            rescue Exception => e
              logger.info "API Exception-#{Time.now}-appInvite-#{params.inspect}-Error-#{e}"
              {message: MSG_ERROR, status: 500}
            end
          end
        end
 ##################################################################
      # => V1 Common Contests
      ##################################################################
      resource :commonContests do
        desc "Common Contest API"
        before { api_params }

        params do
          requires :userId, type: String, allow_blank: false
          requires :securityToken, type: String, allow_blank: false
          requires :versionName, type: String, allow_blank: false
          requires :versionCode, type: String, allow_blank: false
        end

        post do
          begin
            user = User.first #valid_user(params['userId'].to_i, params['securityToken'])
            if user

              commonContestsList = []
              CommonContest.where(status: true).each do |ccl|
                if(ccl.contest_title == 'Most Contest Joined')
                  lb = most_contest_joined
                else
                  lb = most_user_referral
                end

                cContest = {
                  "contestId": ccl.id,
                  "contestName": ccl.contest_title,
                  "contestImage": ccl.contest_image,
                  "firstPrize": ccl.prizelist.split(',').first,
                  "leaderboard": lb
                }

                commonContestsList << cContest
              end

              {message: MSG_SUCCESS, status: 200, commonContestsList: commonContestsList}
            else
              {message: INVALID_USER, status: 500}
            end

          rescue Exception => e
            logger.info "API Exception-#{Time.now}-commonContestsApi-#{params.inspect}-Error-#{e}"
            {message: MSG_ERROR, status: 500}
          end
        end
      end

      ##################################################################
      # => V1 Common Contests Info
      ##################################################################

      resource :commonContestInfo do
        desc "Match List on Home API"
        before {api_params}

        params do
          requires :userId, type: String, allow_blank: false
          requires :securityToken, type: String, allow_blank: false
          requires :versionName, type: String, allow_blank: false
          requires :versionCode, type: String, allow_blank: false
          requires :commonContestId, type: String, allow_blank: false
        end

        post do
          begin
            user = valid_user(params['userId'].to_i, params['securityToken'])
            if user
              currentContest = CommonContest.find_by(id: params['commonContestId'])
              prizelist = CommonContest.find_by(id: params['commonContestId']).prize.select(:id,:rank,:amount)
              rankList = CommonContest.find_by(id: params['commonContestId']).rank
              conditions = currentContest.conditions
              {
                message: MSG_SUCCESS, status: 200,
                conditions: conditions ? conditions.split(",") : [] || [],
                prizeList: prizelist || []
              }
            else
              {message: INVALID_USER, status: 500}
            end

          rescue Exception => e
            logger.info "API Exception-#{Time.now}-commonContestInfoApi-#{params.inspect}-Error-#{e}"
            {message: MSG_ERROR, status: 500}
          end
        end
      end



      end
    end
  end

end
