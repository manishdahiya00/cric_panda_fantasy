class ApplicationController < ActionController::Base  
  PER_PAGE = 15
  BASE_URL = "https://cricpanda.app"  
  TOKEN = 'eabc14e7-c916-47fb-a090-b4816f785fa1'

  helper_method :current_user
  
  def current_user
    if cookies.signed[:token] == TOKEN
      @current_user = 'admin'
    end
    #@current_user ||= User.find(session[:user_id]) if session[:user_id] 
  end  

  def authorize
    redirect_to '/login' unless current_user
  end

end
