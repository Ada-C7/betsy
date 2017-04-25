class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :find_merchant

  def status
    product = Product.find_by(id: params[:id])
    merchant = Merchant.find_by(id: params[:id])
    product.status_change
    if request.referer == product_path(product)
      redirect_to product_path(product)
    elsif
      redirect_to merchant_path(merchant)
    end
  end

  private
  def find_merchant
    if session[:merchant_id]
      @login_merchant = Merchant.find_by(id: session[:merchant_id])
    end
  end

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
