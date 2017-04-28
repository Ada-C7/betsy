class OrdersController < ApplicationController
  before_action :find_order, only: [:edit, :update, :confirmation]
  before_action :find_orderitem, only: [:add, :set, :destroy]
  skip_before_action :require_login, except: [:shipped, :cancelled]

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
    session[:order_id] = nil
    render_404 if !@order
  end

  def set
    if !session[:order_id]
      cart = Order.create
      session[:order_id] = cart.id
    end

    if @item
      if params[:quantity].to_i > @item.product.quantity
        flash[:status] = "alert"
        flash[:result_text] = "Could not add due to insufficient stock."
        redirect_to carts_path
        return
      else
        @item[:quantity] = params[:quantity]
        @item.save
        redirect_to carts_path
        return
      end
    else
      if (params[:quantity].to_i) > (Product.find_by_id(params[:id]).quantity)
        flash[:status] = "alert"
        flash[:result_text] = "Could not add due to insufficient stock."
        redirect_to product_path(params[:id])
        return
      else
        OrderItem.create(order_id: session[:order_id], product_id: params[:id], quantity: params[:quantity])
        redirect_to carts_path
      end
    end
  end

  def add
    if !session[:order_id]
      cart = Order.create
      session[:order_id] = cart.id
    end

    if @item
      if (@item[:quantity] + params[:quantity].to_i) > (@item.product.quantity)
        flash[:status] = "alert"
        flash[:result_text] = "Could not add due to insufficient stock."
        redirect_to product_path(@item.product.id)
        return
      else
        @item[:quantity] += params[:quantity].to_i
        @item.save
        redirect_to carts_path
        return
      end
    else
      if (params[:quantity].to_i) > (Product.find_by_id(params[:id]).quantity)
        flash[:status] = "alert"
        flash[:result_text] = "Could not add due to insufficient stock."
        redirect_to product_path(params[:id])
        return
      else
        OrderItem.create(order_id: session[:order_id], product_id: params[:id], quantity: params[:quantity])
        redirect_to carts_path
      end
    end
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
      order.status = "complete"
    end

    order.save
  end

  def edit
    if @order.order_items == [] || !@order
      flash[:status] = "alert"
      flash[:result_text] = "Cannot check out if your cart is empty"
      render "index"
    end

    @order.order_items.each do |order_item|
      if order_item.quantity > order_item.product.quantity
        flash[:status] = "alert"
        flash[:result_text] = "Oops, someone must have purchased this item."
        redirect_to product_path(@item.product.id)
        return
      end
    end
  end

  def update
    # if there is no order_id in session, there is nothing in the cart and they can't check out
    # if there is an order, but there are no order items, there is nothing in the cart
    # they can't check out
    if !@order || @order.order_items.length == 0
      flash[:status] = "alert"
      flash[:result_text] = "Cannot check out if your cart is empty"
      redirect_to "index"
    end

    @order.status = "paid"
    if @order.update(order_params)
      flash[:status] = :success
      flash[:result_text] = "Successfully updated order number #{ @order.id }"

      @order.order_items.each do |order_item|
        order_item.status = "paid"
        order_item.product.quantity -= order_item.quantity
        order_item.product.save
        order_item.save
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
