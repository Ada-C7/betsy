class UsersController < ApplicationController
  before_action :require_login, except: :index

  def index
    @users = User.all
  end

  def show
    @order_items = @logged_in_user.order_items
    @orders = @order_items.map { |order_item| order_item.order }.uniq
    @orders_by_status = @orders.group_by { |order| order.status }
  end

  def update
    if @logged_in_user.update(user_params)
      flash[:status] = :success
      flash[:result_text] = "Successfully updated profile"
      redirect_to account_path
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Could not update profile"
      flash.now[:messages] = @logged_in_user.errors.messages
      render :edit, status: :bad_request
    end
  end

  def create; end

  def new; end

  def edit; end

  def products; end

  def orders
    @order_items = @logged_in_user.order_items
    @orders = @order_items.map { |order_item| order_item.order }.uniq
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :image_url, :provider, :uid)
  end
end
