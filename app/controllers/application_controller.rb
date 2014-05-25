class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  before_filter :authenticate


  private
  def authenticate
    if current_user.nil?
      flash[:error] = 'Deve estar logado.'
      redirect_to new_sessions_path
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
