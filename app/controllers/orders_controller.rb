class OrdersController < ApplicationController

  def cart
    @products = get_product_order
  end

  # new
  def add_item
    order = current_order
    # check products for availablity - decrease quantity here?
    product_order = ProductOrder.add_product(params[:product_id], session[:order_id] )
    if product_order.valid?
      product_order.save
      redirect_to cart_path
    else
      flash.now[:status] = :failure
      flash[:result_text] = "There was an error - We could not add that item to your cart"
      flash[:messages] = product_order.errors.messages
      redirect_back(fallback_location: root_path)
    end
  end

  def checkout
    @order = current_order
    @products = get_product_order
  end

  def update
    # raise
    order = Order.find_by(id: params[:id])
    order.update_attributes(order_params)
    #need to decrease product quantity for all products?
    if order.valid?
      order.status = "paid"
      order.save
      session[:order_id] = nil
      flash[:status] = :success
      flash[:result_text] = "Thank you for placing your order"
      redirect_to root_path
    elsif !order.valid?
      flash.now[:status] = :failure
      flash[:result_text] = "There was a problem processing your order"
      flash[:messages] = order.errors.messages
      redirect_to checkout_path
    end
  end

  def update_quantity
    # raise
    # params[:id] == product_order
    update_info = params[:product_order]
    product_id = update_info[:product_id]
    quantity = update_info[:quantity]

    product_order = ProductOrder.find_by(id: params[:id])
    product_order.quantity = quantity
    product_order.save

    redirect_back(fallback_location: root_path)
  end

  def remove_product
    product_order = ProductOrder.find_by(order_id: session[:order_id], product_id: params[:id])
    product_order.destroy
    redirect_back(fallback_location: root_path)
  end

private

  def get_product_order
    ProductOrder.where(order_id: session[:order_id])
  end

  # def get_product_order(product_id)
  #   ProductOrder.find_by(order_id: session[:order_id], product_id: product_id)
  # end

  def order_params
    return params.required(:order).permit(:customer_name,
                                          :customer_email,
                                          :customer_address,
                                          :customer_city,
                                          :customer_zipcode,
                                          :customer_state,
                                          :customer_cc_info)
  end
end
