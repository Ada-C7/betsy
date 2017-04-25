class OrderProductsController < ApplicationController

  def index
    @order_products = OrderProduct.all
  end

  def new
    @order_product = OrderProduct.new(product_id: params[:product_id])
  end

  def create
    @order = order
    @order_product = OrderProduct.create!(order_id: @order.id, product_id: params["order_product"]["product_id"], quantity: 1)
    redirect_to products_path
    flash[:messages] = "Your product was added to the cart!"
  end

  def edit
    @order_product = OrderProduct.find_by(id: params[:id])
    @order_product.order
  end

  def update
    @order_product = order.order_products.find_by(product_id: params["order_product"]["product_id"])
    # @order_product = OrderProduct.order.find_by(product_id: params[:product_id])
    @order_product.update_attributes(order_item_params)
  end

  def destroy
    @order_product = order.order_products.find_by(product_id: params["order_product"]["product_id"])
    @order_product.destroy
  end


  private

  def order_item_params
    params.require(:order_product).permit(:quantity, :product_id, :order_id)
  end

  def order
    if session[:order_id]
      Order.find_by(id:session[:order_id])
    else
      order = Order.create
      session[:order_id] = order.id
      order
    end
  end

end

#combination of things from route, route paramaters, and form paramaters
