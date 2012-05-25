class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user
  helper_method :signed_in?

  before_filter :redirect_if_host, :if => ->(){
  	%w(2da.re www.2da.re).include? request.host
  }

  def current_user
	@current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def signed_in?
  	not (session[:user_id].nil?)
  end

  def redirect_if_host
  	render :layout => "beta"
  end

end
