require 'ap'
class OrdersController < ApplicationController
  before_action :place_order?, only: [:edit, :update]

  def index
    @merchant = Merchant.find_by(id: params[:merchant_id])
    @merchant_orders = @merchant.build_orders_hash
  end

  def show
    @order = Order.find_by(id: params[:id])
  end

  def edit
  end

  def update
      @order.update_attributes(order_params)
      if @order.save
        @order.modify_inventory("-")
        flash[:result_text] = "Your order is complete!"
        if session[:order_id]
          session[:order_id] = nil
        end
        # need to update this path once we know where we want it to go
        # redirect_to order_path
        render :summary
      else
        flash.now[:result_text] = "Unable to place your order. Please try again."
        flash.now[:messages] = @order.errors.messages
        render :edit, status: :not_found
      end
  end

  def cancel_order
    @order = Order.find_by(id: params[:id])
    @order.status = "cancelled"
    if @order.save
      @order.modify_inventory("+")
      flash[:message] = "Order successfully cancelled"
    else
      flash[:message] = "Unable to cancel order. Please contact customer service."
    end
    redirect_to products_path
    # patch changes order status from paid to cancelled
  end

  def ship
    @order = Order.find_by(id: params[:id])
    @ops = @order.orderedproducts.select{ |op| op.product.merchant.id == params[:merchant_id].to_i }
    @ops.each do |op|
      op.shipped = true
      op.save
    end
    # check if need to save order status too

    # @order.status = "shipped"
    if @order.save
      flash[:message] = "Order successfully marked as shipped."
    else
      flash[:message] = "Unable to ship order at this time"
    end
    redirect_to merchant_orders_path(params[:merchant_id])
  end

private
  def order_params
    params.require(:order).permit(:status, :email, :mailing_address, :name_on_cc, :cc_num, :cc_exp, :cc_csv, :zip_code)
  end

  def place_order?
    @order = Order.find(params[:id])
    problem_products = @order.verify_inventory
    if !problem_products.empty?
      flash[:message] = "There are not enough of the following products in stock: #{problem_products}"
      redirect_to orderedproducts_path
    end
  end
end
