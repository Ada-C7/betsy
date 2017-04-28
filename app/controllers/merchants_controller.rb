class MerchantsController < ApplicationController
before_action :require_correct_user, only: :show

  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find_by(id: params[:id])
    if @merchant.nil?
      redirect_to root_path
    end
    @orders_by_status = Order.all.by_status(params[:status])
  end

  def show_merchants_order
    @merchant = Merchant.find_by(id: params[:id])
    @order = Order.find_by(id: params[:order_id])
    @merchants_order = @order.merchant_partial_order(@merchant.id)
    # if @merchant.nil?
    #   head :not_found
    # end
  end

  def new
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
    session[:order_id] = nil
    flash[:status] = :success
    flash[:result_text] = "Successfully logged out"
    redirect_to root_path
  end

  private

  def merchant_params
    params.require(:merchant).permit(:username, :email, :oauth_id, :oauth_provider)
  end

end
