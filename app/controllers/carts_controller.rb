class CartsController < ApplicationController
  #don't need to be logged in to view the cart
  skip_before_action :require_login
  
  def show
    @order = Order.find_by_id(current_order)
    @order_items = @order.orderitems
  end
end
