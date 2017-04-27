class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :find_merchant

  private
  def find_merchant
    if session[:merchant_id]
      @login_merchant = Merchant.find_by(id: session[:merchant_id])
    end
  end

  def current_order
    if session[:order_id]
      return Order.find_by(id: session[:order_id])
    else
      order = Order.new
      order.status = "pending"
      order.subtotal = 0
      order.tax = 0
      order.total = 0
      order.save
      session[:order_id] = order.id
      return order
    end
  end
end
