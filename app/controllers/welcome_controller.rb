class WelcomeController < ApplicationController
  before_action :authorize, :only => [:index]

  def index
  	#render layout: false
  end

  def login
    if params[:st] == 'invalid'
      flash[:notice] = 'Invalid Email or Password.'
    end
    if request.post?
      # if params[:email] == 'admin@cricpanda.app' && params[:password] == 'CrkPnda@Ap'
      if params[:email] == 'admin@cricpanda.app' && params[:password] == 'admin'
      #if params[:email] == 'true' && params[:password] == 'true'
        if params[:remember_me]
          cookies.permanent.signed[:token] = { value: TOKEN, expires: 1.week.from_now }
        else
          cookies.permanent.signed[:token] = { value: TOKEN, expires: 1.week.from_now }
        end
        flash[:notice] = 'Admin Login Successfully.'
        redirect_to '/dashboard'
      else
        redirect_to '/login?st=invalid'
      end
    else
      if cookies[:token] == TOKEN
        redirect_to '/dashboard'
      else
        render :layout => false
      end
    end
  end

  def logout
    cookies.delete(:token)
    flash[:notice] = 'Logout Successfully.'
    redirect_to '/login'
  end

  def invite
    begin
      @referral_code = params['referral_code']
      if (request.user_agent.include? "iPad") || (request.user_agent.include? "iPhone")
        @playbutton = "https://apps.apple.com/app/id1484264613"
      else
        @playbutton = "market://details?id=com.cashpanda.android&referrer=utm_source%3DINVITE%26utm_medium%3D#{@referral_code}%26utm_term%3DINVITE%26utm_content%3DINVITE%26utm_campaign%3DINVITE"
      end
      logger.info "Invite-Page-#{Time.now}-Params-#{params.inspect}-UserAgent-#{request.user_agent}"
      render :layout => false

    rescue Exception => e
      logger.info "Invite-Page-Exception-#{Time.now}-Error-#{e}-Params-#{params.inspect}-UserAgent-#{request.user_agent}"
      render :layout => false
    end
  end

end
