class OrdersController < ApplicationController
  before_action :get_order, only: [:cart, :checkout]

  def cart; end
  def checkout; end

  def add_product
    current_order
    product_order = ProductOrder.add_product(params[:product_id], session[:order_id] )

    if product_order.valid?
      product_order.save
      redirect_to cart_path
    else
      flash.now[:status] = :failure
      flash[:result_text] = "There was an error - We could not add that item to your cart"
      flash[:messages] = product_order.errors.messages
      redirect_back(fallback_location: cart_path)
    end
  end

  def update
    # raise
    order = Order.find_by(id: params[:id])
    order.update_attributes(order_params)
    #need to decrease product quantity for all products?
    if order.valid?
      order.calculate_totals
      order.handle_inventory
      order.status = "paid"
      order.save
      session[:order_id] = nil
      flash[:status] = :success
      flash[:result_text] = "Thank you for placing your order"
      redirect_to root_path
    elsif !order.valid?
      flash[:status] = :failure
      flash[:result_text] = "There was a problem processing your order"
      flash[:messages] = order.errors.messages
      redirect_to checkout_path
    end
  end

  def update_quantity
    update_info = params[:product_order]
    product_id = update_info[:product_id]
    quantity = update_info[:quantity]

    product_order = ProductOrder.find_by(id: params[:id])
    product_order.quantity = quantity

    if product_order.valid?
      product_order.save
    else
      flash[:status] = :failure
      flash[:result_text] = "There was a problem updating the quantity"
      flash[:messages] = product_order.errors.messages
    end
    redirect_back(fallback_location: root_path)
  end

  def remove_product
    product_order = ProductOrder.find_by(order_id: session[:order_id], product_id: params[:id])
    product_order.destroy if product_order
    redirect_back(fallback_location: root_path)
  end

private

  def get_order
    @order = current_order
    @order.calculate_totals
  end

  # def get_product_order
  #   ProductOrder.where(order_id: session[:order_id])
  # end

  # def decrease_product_inventory(products)
  #   product.each { |prodcut| product. }
  # end

  def order_params
    return params.required(:order).permit(:customer_name,
                                          :customer_email,
                                          :customer_address,
                                          :customer_city,
                                          :customer_zipcode,
                                          :customer_state,
                                          :credit_card_number)
  end
end
