class OrdersController < ApplicationController
  before_action :find_order, only: [:show, :edit, :update]
  before_action :find_orderitem, only: [:add, :remove, :set]

  def index
    if session[:order_id]
      @order_items = OrderItem.where(order_id: session[:order_id])
    end
  end

  def show
    render_404 if !@order
  end

  def add
    if !session[:order_id]
      cart = Order.create
      session[:order_id] = cart.id
    end

    if @item
      @item[:quantity] += 1
      @item.save
    else
      OrderItem.create(order_id: session[:order_id], product_id: params[:id], quantity: 1)
    end
    redirect_to carts_path
  end

  def remove
    if @item
      @item[:quantity] -= 1
      @item.save
    end

    @item.destroy if @item[:quantity] == 0

    redirect_to carts_path
  end

  def set
    if !session[:order_id]
      cart = Order.create
      session[:order_id] = cart.id
    end

    if @item
      @item[:quantity] = params[:quantity]
      @item.save
    else
      OrderItem.create(order_id: session[:order_id], product_id: params[:id], quantity: params[:quantity])
    end

    @item.destroy if @item[:quantity] == 0
    redirect_to carts_path
  end

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
    # and remove purchased products from the database
    if @order.update(order_params)
      flash[:success] = "Successfully updated order number #{ @order.id } "
      # this should redirect to an order summary view
      redirect_to orders_path
    else
      flash.now[:error] = "A problem occurred: Could not update order number #{ @order.id }"
      render "edit"
    end
  end

  def destroy
    if session[:order_id]
      @order_items = OrderItem.where(order_id: session[:order_id])
      @order_items.destroy
    end
  end

  private

  def find_order
    @order = Order.find_by_id(session[:order_id])
  end

  def find_orderitem
    @item = OrderItem.find_by( order_id: session[:order_id], product_id: params[:id])
  end

  def order_params
    params.require(:order).permit(:email, :billing_name, :address, :card_number, :card_expiration, :cvv, :zipcode)
  end
end
