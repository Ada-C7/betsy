class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :require_login
  before_action :find_user
  before_action :cart_count
  helper_method :find_user

  def require_login
    if !session[:user_id]
      flash[:status] = "warning"
      flash[:result_text] = "You must be logged in to view this page."
      redirect_to :root, status: :bad_request
    end
  end

  def render_404
    render file: "#{ Rails.root }/public/404.html", status: 404
  end

  def find_user
    if session[:user_id]
      @logged_in_user ||= User.find_by_id(session[:user_id])
    end
  end

  def cart_count
    cart = Order.find_by_id(session[:order_id])
    if cart.nil?
      @cart_count = 0
    else
      @cart_count = cart.order_items.map { |order_item|
        order_item.quantity
      }.inject(0, :+)
    end
  end
end
