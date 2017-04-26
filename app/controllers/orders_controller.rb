class OrdersController < ApplicationController
  before_action :find_order, only: [:edit, :update]
  before_action :find_orderitem, only: [:add, :set, :destroy]
  before_action :require_login, only: [:shipped, :cancelled]

  # cart
  def index
    if session[:order_id]
      @order_items = OrderItem.where(order_id: session[:order_id])
    end
  end

  def show
    @order = Order.find_by_id(params[:id])
    render_404 if !@order
  end

  def confirmation
    @order = Order.find_by_id(params[:id])
    render_404 if !@order
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

    redirect_to carts_path
  end

  def add
    if !session[:order_id]
      cart = Order.create
      session[:order_id] = cart.id
    end

    if @item
      @item[:quantity] += params[:quantity].to_i
      @item.save
    else
      OrderItem.create(order_id: session[:order_id], product_id: params[:id], quantity: params[:quantity])
    end

    redirect_to carts_path
  end

  def shipped
    @order_item = OrderItem.find_by_id(params[:id])
    @order_item.status = "shipped"
    @order_item.save

    complete_order
    redirect_back(fallback_location: account_orders_path)
  end

  def cancelled
    @order_item = OrderItem.find_by_id(params[:id])
    @order_item.status = "cancelled"
    @order_item.save

    complete_order
    redirect_back(fallback_location: account_orders_path)
  end

  def complete_order
    order = Order.find_by_id(@order_item.order_id)
    found_shipped = 0
    found_paid = 0
    order.order_items.each do |order_item|
      if order_item.status == "shipped"
        found_shipped = 1
      elsif order_item.status != "cancelled"
        found_paid = 1
      end
    end

    # if there are no paid items or shipped items, then items are all cancelled
    if found_paid == 0 && found_shipped == 0
      order.status = "cancelled"
    # otherwise if there are no paid items, then all items are shipped or
    # there is combination of shipped and cancelled items only
    elsif found_paid == 0
      order.status = "shipped"
    end

    order.save
  end

  def edit
    render_404 if !@order
  end

  def update
    # if there is no order_id in session, there is nothing in the cart and they can't check out
    # if there is an order, but there are no order items, there is nothing in the cart
    # they can't check out
    if !@order || @order.order_items.length == 0
      # TODO turn these into helpful flash messages
      render_404
    end

    @order.status = "paid"
    if @order.update(order_params)
      flash[:status] = :success
      flash[:result_text] = "Successfully updated order number #{ @order.id } "
      session[:order_id] = nil

      @order.order_items.each do |order_item|
        order_item.product.quantity -= order_item.quantity
        order_item.product.save
      end

      redirect_to confirmation_path(@order.id)
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "A problem occurred: Could not update order number #{ @order.id }"
      render "edit"
    end
  end

  def destroy
    @item.destroy if @item
    session[:order_id] = nil if !@order = Order.find_by_id(session[:order_id])
    flash[:status] = :success
    flash[:result_text] = "Successfully removed #{@item.product.name} from cart"
    redirect_to carts_path
  end

  private

  def find_order
    @order = Order.find_by_id(session[:order_id])
  end

  def find_orderitem
    @item = OrderItem.find_by(order_id: session[:order_id], product_id: params[:id])
  end

  def order_params
    params.require(:order).permit(:email, :billing_name, :address, :card_number, :card_expiration, :cvv, :zipcode)
  end
end
