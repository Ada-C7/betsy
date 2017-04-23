class OrdersController < ApplicationController
  def new
  end

  def cart
    @products = Productorder.where(orders_id: session[:order_id])
  end

  def add_item
    order = current_order
    product_order = Productorder.add_product(params[:product_id], session[:order_id] )
    if product_order.valid?
      product_order.save
      redirect_to cart_path
    else
      flash.now[:failure] = "Could not add item"
      render :back
    end
  end

  def checkout
    order = current_order

  end
end
