class OrdersController < ApplicationController
  before_action :find_order, only: [:add_product_order, :remove_product_order, :show]
  before_action :find_order_product, only: [:show, :change_cart_quantity]

  def index
    params[:vendor_id]
    vendor = Vendor.find_by(id: params[:vendor_id])
    @orders = vendor.orders
  end

  def show
    find_order
    @op = @order.order_products.where(product_id: params[:product_id], order_id: @order.id).first
  end

  def add_product_order
    if @order.order_products.find_by_product_id(params[:product_id]) != nil

      if check_avail
        find_order_product
        @op.quantity += 1
        @op.save
        flash[:success] = "quantity increased"
        redirect_to root_path
      else
        flash[:error] = "not enough inventory"
        redirect_to root_path
      end
    else
      create_order_product
    end
  end

  def change_cart_quantity
    @op.quantity = params[:quantity]
  end

  def remove_product_order
    op = @order.order_products.find_by_product_id(params[:product_id])
    if op.quantity > 1
      op.quantity -= 1
      if op.save
        add_product_inventory(params[:product_id])
        flash[:success] = "Quantity 1 removed from cart"
      else
        flash[:error] = "Unable to remove from cart"
      end
    else
      op.destroy
      flash[:success] = "Product removed from cart"
    end
    redirect_to root_path
  end

  def clear_cart
  end

  def add_product_inventory(id)
    p = Product.find_by_id(id)
    p.inventory += 1
    p.save
  end

  def remove_product_inventory(id)
    p = Product.find_by_id(id)
    p.inventory -= 1
    p.save
  end

  def create
    @order = Order.create order_params
    unless @order.id == nil
      flash[:sucess] = "Your order has been succesfully submitted"
      redirect_to root_path
    else
      flash.now[:error] = "Error occured, try again".
      render "new"
    end
  end

  def checkout
  end

  private

  def check_avail
    p = Product.find_by_id(params[:product_id])
    return true if p.inventory > 0
    return false
  end

  def order_params
    params.require(:order).permit(:purchase_date, :status, :cust_email, :cust_address, :credit_card, :cc_expire)
  end

  def find_order
    # if session[:order_id]
    @order = Order.find(1)
    # else
      # @order = Order.new
    # end
  end

  def find_order_product
    @op = @order.order_products.where(product_id: params[:product_id], order_id: @order.id).first
  end

  def create_order_product
    o = OrderProduct.create
    o.product_id = params[:product_id]
    o.order_id = @order.id
    o.quantity = 1
    o.save
    @order.order_products << o
    if @order.save
      remove_product_inventory(params[:product_id])
      flash[:success] = "Item added to cart"
    else
      flash[:error] = "Unable to add item to cart"
    end
    redirect_to root_path
  end
end
