class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user

  def require_user
    redirect_to home_path and return if current_user.blank?
  end

  def require_no_user
    redirect_to presentations_url and return if current_user.present?
  end

  private

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by_id(session[:user_id])
      unless @current_user
        session[:user_id] = nil
      end
    end
    @current_user
  end

end
