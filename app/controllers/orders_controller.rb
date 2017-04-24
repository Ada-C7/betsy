class OrdersController < ApplicationController
  before_action :find_order, only: [:show, :edit, :update]

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

  # def new
  # end

  def show
    render_404 if !@order
  end

  # def create
  #   # we don't create, because the order already exists, but we update
  #   @order = Order.create order_params
  #   if @order.id != nil
  #     redirect_to orders_path
  #   else
  #     render "new"
  #   end
  # end

  def edit
    # instead of creating new order I will look up the existing order
    # using order_id that is stored in session
    # if there is no order_id in session, there is nothing in the cart and they can't check out
    # if there is an order, but there are no order items, there is nothing in the cart
    # and they can't check out
    render_404 if !@order
  end

  def update
    # is updating the order with billing information from the work
    # find the order using order_id stored in session
    # (it is stored there when initial order is created)
    # updating the order also needs to change status from pending to paid and
    # delete the order_id from session
    if @order.update(order_params)
      flash[:success] = "Successfully updated order number #{ @order.id} "
      # this should redirect to an order summary view
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
    @order = Order.find_by_id(session[:order_id])
  end

  def order_params
    params.require(:order).permit(:email, :billing_name, :address, :card_number, :card_expiration, :cvv, :zipcode)
  end
end
