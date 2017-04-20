class OrdersController < ApplicationController

  def index
    @orders = Order.all
    respond_to do |format|
      format.html
      format.csv { send_data @orders.to_csv }
    end
  end

  def create
    @order = Order.new
  end

  def checkout
    @order = Order.find_by_id(session[:order_id])
  end
  
end
