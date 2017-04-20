class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def require_login
    if !session[:user_id]
      flash[:warning] = "You must be logged in to view this page"
      redirect_to :root
    end
  end

  def current_user
    @login_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def render_404
    render file: "#{ Rails.root }/public/404.html", status: 404
  end
end
