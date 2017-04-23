class OrdersController < ApplicationController
  before_action :find_book, only: [:show, :edit, :update]

  def index
    # lists of all orders belonging to a specific user(merchant)
    if params[:user_id]
      # retrieve the orders specific for this user
      # this will give us all orders belonging to the user specified in the nested route
      # if we decide to usenested routes for the user accounts
      @orders = Order.includes(:users).where(users: { id: params[:user_id]})
    else
  # normal scenario
    end
      @orders = Order.all
  end

  def new
    @order = Order.new
  end

  def show
    render_404 if !@order
  end

  def create
    @order = Order.create order_params
    if @order.id != nil
      redirect_to orders_path
    else
      render "new"
    end
  end

  def edit
    render_404 if !@order
  end

  def update
    @order = Order.find(params[:id])

    if @order.update(order_params)
      flash[:success] = "Successfully updated order number #{ @order.id} "
      # not sure where to redirect
      redirect_to orders_path
    else
      flash.now[:error] = "A problem occurred: Could not update order number #{ @order.id }"
      render "edit"
    end
  end

  def destroy
    # user stories do not mention deleting orders
    # maybe we should jsut mark them cancelled instead of deleting them,
    # because that would be confusing for the user(merchant), if the
    # orders just disappeared
  end

  private

  def find_order
    @order = Order.find_by_id(params[:id])
  end

  def order_params
    params.require(:order).permit(:email, :billing_name, :address, :card_number, :card_expiration, :cvv, :zipcode)
  end
end
