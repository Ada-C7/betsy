class OrdersController < ApplicationController

  def cart
    @products = Productorder.where(order_id: session[:order_id])
  end
  # new
  def add_item
    order = current_order

    if order.nil?
      raise
    end

    product_order = Productorder.add_product(params[:product_id], session[:order_id] )
    if product_order.valid?
      product_order.save
      redirect_to cart_path
    else
      flash.now[:failure] = "Could not add item"
      render :back, status: :bad_request
    end
  end

  # edit
  def checkout
    @order = current_order
  end

  # buy method
  def update
    validate_user_info(params)
  end

private

# strong params
end
