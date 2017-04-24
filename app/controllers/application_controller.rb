class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_order

    if !session[:order_id].nil?
      return Order.find(session[:order_id])
    else
      order = Order.new
      order.status = "pending"
      order.save
      session[:order_id] = order.id
      return order
    end
  end
end
