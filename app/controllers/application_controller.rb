class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :find_user
  helper_method :find_user

  def render_404
    render file: "#{ Rails.root }/public/404.html", status: 404
  end

  def find_user
    if session[:user_id]
      @logged_in_user ||= User.find_by_id(session[:user_id])
    end
  end
end
