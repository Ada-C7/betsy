class OrderProductsController < ApplicationController
  before_action :find_order_product, only: [:update, :ship, :destroy]
  before_action :find_current_order, only: [:create, :update, :destroy]

  def create
    @current_order = current_order
    @order_product = OrderProduct.new(quantity: params[:quantity], order_id: @current_order.id, product_id: params[:product_id])
    if @order_product.save
      redirect_to shopping_cart_path
      flash[:success] = "You successfully added #{@order_product.product.name} to the cart"
    else
      redirect_to product_path(@order_product.product_id)
    end
  end

  def update
    @order_product.quantity = params[:quantity].to_i
    if @order_product.save
      redirect_to shopping_cart_path
    end
  end

  def ship
    if @order_product.order.status != "paid"
      flash[:message] = "You cannot ship this product, since order status is #{@order_product.order.status}"
      redirect_to merchant_order_view_path(@order_product.product.merchant_id  , @order_product.order_id )
      return
    end

    @order_product.status = "shipped"
    if @order_product.save
      flash[:success] = "You successfully shipped this product"
      redirect_to merchant_order_view_path(@order_product.product.merchant_id  , @order_product.order_id )
    end

    order = @order_product.order
    order.complete?
  end

  def destroy
    if @order_product.destroy
      if destroy_whole_order?(@order)
        @order.destroy
        session[:order_id] = nil
      end
      flash[:success] = "You successfully deleted #{@order_product.product.name} from the shopping cart"
      redirect_to shopping_cart_path
    end
  end

  private
  def order_products_params
    params.require(:order_products).permit(:quantity, :order_id, :product_id)
  end

  def destroy_whole_order?(order)
    destroy_order = true
    order.order_products.each do |op|
      destroy_order = false if op != nil
    end
    return destroy_order
  end

  def find_order_product
    @order_product = OrderProduct.find(params[:id])
  end

  def find_current_order
    @order = current_order
  end

end
