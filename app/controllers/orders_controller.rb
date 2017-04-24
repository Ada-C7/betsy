class OrdersController < ApplicationController

  def cart
    # raise
    @products = Productorder.where(order_id: session[:order_id])
  end

  # new
  def add_item
    order = current_order

    if order.nil?
      raise
    end
    # check products for availablity - decrease quanitity here?
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
    @products = Productorder.where(order_id: session[:order_id])
  end

  # buy method
  def update
    @order = current_order

    # how do I validate all the income - need to write my own helper methods..
    # @order.validate_user_info(params)
    @order.update_attributes(order_params)

    #need to decrease product quantity for all products
    # loop through products and call product class method on each to decrease

    if @order.valid?
      @order.status = "paid"
      @order.save
      session[:order_id] = nil
      # raise
      flash[:success] = "Thank you for placing your order"
      redirect_to root_path
    end
    # raise
  end

private
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
