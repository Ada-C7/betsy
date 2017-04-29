class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :lookup_user

  private
  def lookup_user
    unless session[:user_id].nil?
      @current_user = Merchant.find_by(id: session[:user_id])
    end
  end

  def require_login
    lookup_user
    if @current_user.nil?
      flash[:result_text] = "You must login to see that page"
      redirect_to root_path
    end
  end

end
