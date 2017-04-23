class OrdersController < ApplicationController
  def new
  end

  def cart
    @products = Productorder.where(orders_id: session[:order_id])
    # raise
  end

  def add_item
    order = current_order
    product_order = Productorder.new
    product_order.products_id = params[:product_id]
    product_order.orders_id = session[:order_id]
    product_order.quantity = 1
    # raise
    product_order.save
    redirect_to cart_path
  end
end
