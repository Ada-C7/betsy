class OrdersController < ApplicationController

  def index
    @orders = Order.all
    respond_to do |format|
      format.html
      format.csv { send_data @orders.to_csv }
    end
  end

  def checkout
    @order = Order.find_by_id(session[:order_id])
    if @order.nil?
      flash[:warning] = "Please add an item to your cart to check out"
      redirect_to root_path
    end
  end

  def update #place order
    @order = Order.find_by_id(session[:order_id])
    if @order
      @order.status = "Paid"
      @order.email = order_params[:email]
      @order.name_on_cc = order_params[:name_on_cc]
      @order.cc_number = order_params[:cc_number]
      @order.cc_ccv = order_params[:cc_ccv]
      @order.billing_zip = order_params[:billing_zip]
      @order.address = order_params[:address]
      if @order.save
        session[:order_id] = nil
        @order.order_items.each do |item|
          #updates the stock of each of the products
          item.product.stock = item.product.stock - item.quantity
          item.product.save
          #need to test this, and possibly pull out into model method?
        end
        #Should update the merchant page somehow with a notice of a new order?
      end
    end
  end

  private

  def order_params
      params.require(:order).permit(:email, :name_on_cc, :cc_number, :cc_ccv, :billing_zip, :address)
  end
end
