class OrdersController < ApplicationController

  def cart
    @products = get_products
  end

  # new
  def add_item
    order = get_order
    # check products for availablity - decrease quantity here?

    product_order = ProductOrder.add_product(params[:product_id], session[:order_id] )

    if product_order.valid?
      product_order.save
      redirect_to cart_path
    else
      flash[:failure] = "Could not add item"
      redirect_back(fallback_location: root_path)
    end
  end

  # edit
  def checkout
    @order = current_order
    @products = ProductOrder.where(order_id: session[:order_id])
    # raise
  end

  # buy method
  def update
    order = current_order
    order.update_attributes(order_params)

    #need to decrease product quantity for all products?
    if order.valid?
      order.status = "paid"
      order.save
      session[:order_id] = nil
      flash[:success] = "Thank you for placing your order"
      redirect_to root_path
    end
    # raise
  end

  def update_quantity
    update_info = params[:product_order]
    product_id = update_info[:product_id]
    quantity = update_info[:quantity]
    product_order = ProductOrder.find_by(order_id: session[:order_id], product_id: product_id)

    product_order.quantity = quantity
    product_order.save

    redirect_back(fallback_location: root_path)
  end

  def remove_product
    # order = current_order
    # product = Product.find_by(id: params[:id])
    product_order = ProductOrder.find_by(order_id: session[:order_id], product_id: params[:id])
    # need to add quant back to product?
    product_order.destroy
    redirect_back(fallback_location: root_path) 
    # raise
  end

private

  def get_order
    current_order
  end

  def get_products
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
