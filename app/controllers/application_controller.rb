class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :find_merchant

  def find_merchant
    if session[:merchant_id]
      @current_user = Merchant.find_by(id: session[:merchant_id])
    end
  end
end
