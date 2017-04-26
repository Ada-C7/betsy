class UsersController < ApplicationController
  before_action :require_login, except: :index

  def index
    @users = User.all
  end

  def show
    # creates a unique list of the logged in user's order statuses
    @order_statuses = @logged_in_user.order_items.map { |order_item|
      order_item.order.status
    }.uniq
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

  def edit; end

  def products; end

  def orders
    @order_items = @logged_in_user.order_items
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :image_url, :provider, :uid)
  end

  def require_login
    if !session[:user_id]
      flash[:status] = "warning"
      flash[:result_text] = "You must be logged in to view this page."
      redirect_to :root, status: :bad_request
    end
  end

end
