class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :current_order_items, :total_items_in_cart
  helper_method :render_404
  helper_method :can_review?, :can_edit?, :can_add_new_product?, :highest_rated_products
  helper_method :order_status_show

  def render_404
    render file: "#{ Rails.root }/public/404.html", status: 404
  end

  private

  def order_status_show
    if params[:order_status] == nil
      order_status ="All"
    elsif params[:order_status] == "complete"
      order_status = "Complete"
    else
      order_status = "Incomplete"
    end
      return order_status
  end

  def current_user
    @logged_in_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_order_items
    if session[:order_id]
      return Order.find_by_id(session[:order_id])
    else
      return false
    end
  end

  def total_items_in_cart
    total = 0
    if current_order_items
      current_order_items.order_items.each do |item|
        total += item.quantity
      end
    end
    return total
  end

  def can_add_new_product?
    if !current_user
      return false
    else
      if current_user.id == params[:user_id].to_i
        return true
      else
        return false
      end
    end
  end

  def check_owner
    if !current_user || current_user.id != params[:id].to_i
      flash[:failure] = "You must be the owner of this page to view it"
      redirect_to root_path
    end
  end

  def can_edit?
    # if there is a user logged in, see if the user's id matches the user_id in the product params
    if current_user
      # user = User.find_by_id(session[:user_id])
      # if someone is logged in
      product = Product.find_by_id(params[:id])
      if current_user.id == product.user_id
        # if logged-in user is owner of product
        return true
      else
        # if it is not user's product, no edit button
        return false
      end
    else
      # if no one is logged in you can't edit
      return false
    end
  end


  def can_review?
    if current_user
      # user = User.find_by_id(session[:user_id])
      product = Product.find_by_id(params[:id])

      if current_user.id == product.user_id
        # if someone is logged in and they are the owner of the product -- they can't review it
        return false
      else
        return true
      end
    else
      return true
    end

  end


end
