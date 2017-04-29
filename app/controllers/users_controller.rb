class UsersController < ApplicationController
  before_action :require_login, only: [:show]

  def index
    @users = User.all
  end

  def new
    @user = User.new

  end

  def show
    @user = User.find_by(id: params[:id])
    head :not_found if @user.nil?
  end



  def create
    new
    if @user.update(user_params)
      session[:user_id] = @user.id
      redirect_to users_path
    else
      render :new, status: :bad_request
    end
  end

  def quantity
      items = 0
      @user = ProductOrder.find_by_id(params[:user_id].to_i)
      @user.product_orderscart.product_orders.each do |item|
          items += item.quantity
      end
      items
  end



  def update
    @product = Product.find(params[:id])

    if @product.update_attributes(params[:status])
      flash[:notice] = 'product was successfully created.'
    else
      flash[:notice] = "Error creating product"
      flash[:messages] = @product.errors.messages
    end

order  end

  # ~~~~~~~~~~~~~~~~~~~~~~~~ooooooooooooooooooooooo~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  private

  def user_params
    params.require(:user).permit(:username, :email)
  end
end
