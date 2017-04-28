class MerchantsController < ApplicationController
  before_action :require_login, only: [:all_products]

  def index
    @merchants = Merchant.all
  end

  def create
    @merchant = Merchant.new(merchant_params)
    if @merchant.save
      flash[:status] = :success
      flash[:result_text] = "Successfully created Merchant #{@merchant.username}"
      redirect_to merchants_path
    else
      flash[:status] = :failure
      flash[:result_text] = "Could not create Merchant #{@merchant.username}"
      flash[:messages] = @merchant.errors.messages
      render :new, status: :bad_request
    end
  end

  def show
    @merchant = Merchant.find_by(id: params[:id])
    @products = @merchant.products.select { |product| !product.retired && product.inventory > 0 }
    if @merchant.nil?
      head :not_found
    end
    # render :status => 404 unless @merchant
    # render_404 unless @merchant
  end

  def auth_callback
    auth_hash = request.env['omniauth.auth']

    user = Merchant.find_by(oauth_provider: params[:provider], oauth_uid: auth_hash['uid'])

    if user.nil?
      user = Merchant.from_github(auth_hash)

      if user.save
        session[:user_id] = user.id
        flash[:status] = :success
        flash[:result_text] = "Successfully logged in as user #{user.username} "
      else
        flash[:status] = :failure
        flash[:result_text] = "Could not log in"
      end
    else
      session[:user_id] = user.id
      flash[:status] = :success
      flash[:result_text] = "Welcome back, #{user.username}"
    end
    redirect_to products_path
  end

  def destroy
    session[:user_id] = nil
    flash[:status] = :success
    flash[:result_text] = 'You are logged out'
    redirect_to products_path
  end

  def all_products
    require_login
    @merchant = Merchant.find_by(id: @current_user.id)
    render :all_products
  end

  private

  def merchant_params
    return params.require(:merchant).permit(:username, :email)
  end
end
