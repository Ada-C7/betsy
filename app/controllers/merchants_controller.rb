class MerchantsController < ApplicationController
  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find_by(id: params[:id])
  end

  def new
    @merchant = Merchant.new
  end

  def create
    auth_hash = request.env['omniauth.auth']
    merchant = Merchant.find_by(oauth_provider: params[:provider], oauth_id: auth_hash["uid"])
    if merchant.nil?
      merchant = Merchant.from_github(auth_hash)
      if merchant.save
        session[:user_id] = merchant.id
        flash[:message] = "Successfully logged in as new merchant #{merchant.username}!"
      else
        flash.now[:message] = "Could not log in"
        merchant.errors.messages.each do |field, problem|
          flash[:field] = problem.join(', ')
        end
      end
    else
      session[:user_id] = merchant.id
      flash[:message] = "Successfully logged in as existing merchant #{merchant.username}"
    end
    redirect_to root_path
  end

  def logout
    session[:user_id] = nil
    flash[:status] = :success
    flash[:result_text] = "Successfully logged out"
    redirect_to root_path
  end

  private

  def merchant_params
    params.require(:merchant).permit(:username, :email, :oauth_id, :oauth_provider)
  end
end
