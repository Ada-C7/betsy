class OrdersController < ApplicationController
  # before_action :create_order, only: [:new, :create]
  before_action :find_current_order, only: [:new, :create, :edit, :update]

  def new; end

  def create
    @order.save
  end

  def shopping_cart
    if session[:order_id] != nil
      find_current_order
      @shopping_cart_products = OrderProduct.all.where(order_id: @order.id)
    else
      @shopping_cart_products = nil
    end
  end

  def show
    @order = Order.find_by(id: params[:id])
    if @order.nil?
      flash[:message] = "Could not find this order"
      redirect_to root_path
    end
  end

  def edit; end

  def update
    @order = Order.find_by(id: params[:id])
    @order.update_attributes(order_update_params)
    @order.status = "paid"
    @order.paid_at =  DateTime.now

    if @order.save
      flash[:success] = "You successfully created your order"
      change_stock(@order, "remove")
      redirect_to order_path(@order.id)
      session[:order_id] = nil
    else
      render :edit, status: :bad_request
    end
  end

  def cancel
    @order = Order.find(params[:id])
    @order.status = "cancelled"
    change_stock(@order, "add")
    if @order.save
      flash[:success] = "You successfully cancelled your order"
      redirect_to order_path(@order.id)
    end
  end

  # def destroy
  #   current_order.order_products.each do |op|
  #     op.destroy
  #   end
  #   current_order.destroy
  #   session[:order_id] = nil
  #   redirect_to products_path
  # end
  #

  private

  def order_update_params
    params.require(:order).permit(:email, :mailing_address,:card_name, :credit_card, :card_expiration, :cvv, :zip_code)
  end

  def order_params
    params.require(:order).permit(:status, :email, :mailing_address,:card_name, :credit_card, :card_expiration, :cvv, :zip_code, :paid_at)
  end

  def create_order
    @order = Order.new(order_params)
  end

  def find_current_order
    @order = current_order
  end

  def change_stock(order, action)
    order_products = OrderProduct.where(order_id: order.id)
    order_products.each do |op|
      if action == "remove"
        op.product.stock -= op.quantity
        op.product.save
      elsif action == "add"
        op.product.stock += op.quantity
        op.product.save
      end
    end
  end

end
