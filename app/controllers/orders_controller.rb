class OrdersController < ApplicationController
  before_action :find_order, only: [:edit, :update]
  before_action :find_orderitem, only: [:add, :set, :destroy]

  # cart
  def index
    if session[:order_id]
      @order_items = OrderItem.where(order_id: session[:order_id])
    end
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

  def edit
    render_404 if !@order
  end

  def update
    # if there is no order_id in session, there is nothing in the cart and they can't check out
    render_404 if !@order
    # if there is an order, but there are no order items, there is nothing in the cart
    # they can't check out
    render_404 if @order.order_items.length == 0

    # TODO remove purchased products from the database!!!!!!
    @order.status = "paid"
    if @order.update(order_params)
      flash[:status] = :success
      flash[:result_text] = "Successfully updated order number #{ @order.id } "
      session[:order_id] = nil
      # this should redirect to an order summary view
      redirect_to confirmation_path(@order.id)
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "A problem occurred: Could not update order number #{ @order.id }"
      render "edit"
    end
  end

  def destroy
    @item.destroy if @item
    session[:order_id] = nil
    # not working as of yet
    flash[:status] = :success
    flash[:result_text] = "Successfully removed #{@item} from cart"
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
