class MerchantsController < ApplicationController
  #looks for the merchant based on the params[:id] value for these methods
  before_action :find_merchant, only: [:show, :edit, :update]
  #we want to make sure the user and the merchant are the same for editing, deleting a merchant
  before_action :user_matches_merchant, except: [:index, :show, :new, :create]

  #you can see a list of merchants, create the merchant and show public merchant info without being logged in
  skip_before_action :require_login, only: [:index, :create, :show]

  def index
    @merchants = Merchant.all
  end

  def create
    @merchant = Merchant.create merchant_params
    @merchant.name = @merchant.username

    unless @merchant.id == nil
      flash[:success] = "Merchant #{@merchant.name} successfully created.\nEdit your info on your account page."
      redirect_to merchants_path
    else
      flash.now[:error] = "Merchant not created. Ghosts must be mad."
      render "new"
    end
  end

  def show
    if !@merchant
      render_404
    end
  end

  def edit; end

  def update

    @merchant.name = merchant_params[:name]
    @merchant.username = merchant_params[:username]
    @merchant.email  = merchant_params[:email]
    @merchant.description = merchant_params[:description]

    if @merchant.save
      redirect_to merchant_path(@merchant.id)
    else
      render "edit"
    end

  end

  def products
    @products = Merchant.find_by_id(params[:id]).products
  end




  private

  def merchant_params
    params.require(:merchant).permit(:name, :username, :email, :description, :uid, :provider)
  end

  def find_merchant
    @merchant = Merchant.find_by_id params[:id]
  end


end
