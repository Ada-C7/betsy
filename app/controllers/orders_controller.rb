class OrdersController < ApplicationController
  before_action :find_order, only: [:added_to_cart, :cart]
  before_action :find_order_merchant, only: [:show, :update]

#### Making an order

  def add_to_cart
    # session[:order_id] = nil
    if session[:order_id]
      @order = Order.find_by(id: session[:order_id])
    else
      @products = Product.all
      @products.each do |product|
        product.original_stock = product.stock
        product.save
      end
      @order = Order.new
      @order.save(validate: false)
      session[:order_id] = @order.id
      @order.status = "pending"
    end
    @orderproduct = Orderproduct.create(orderproduct_params)

    if @orderproduct

      flash[:result_text] = "Successfully added to Cart"
      flash[:status] = :success
      product = Product.find_by(id: params[:id])
      product.stock -= @orderproduct.quantity
      product.save
      @orderproduct.status = "processing"
      @orderproduct.save

    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Could not create a Cart"
      flash.now[:messages] = @order.errors.messages
      render :product, status: :bad_request
    end
    redirect_to product_orders_added_to_cart_path(product_id: params[:id])
  end

  def added_to_cart

  end

  def cart
  end

  def update_qty
    @order = Order.find_by(id: params[:id])
    @orderproduct = Orderproduct.find_by(id: params[:orderproduct][:id])
    start_qty = @orderproduct.quantity
    @orderproduct.update(orderproduct_params)
    if @orderproduct.save
      product = Product.find_by(id: @orderproduct.product_id)
      product.stock += start_qty - @orderproduct.quantity
      product.save
      redirect_to cart_path(id: params[:id])
    else
      render :cart, status: :bad_request
    end
  end

  def remove_from_cart
    @orderproduct = Orderproduct.find_by(id: params[:orderproduct_id])
    start_qty = @orderproduct.quantity
    if @orderproduct.nil?
      head :not_found
    else
      product = Product.find_by(id: @orderproduct.product_id)
      product.stock += start_qty - @orderproduct.quantity
      product.save
      @orderproduct.destroy
      redirect_to cart_path(id: params[:order_id])
    end
  end

  def checkout
    @order = Order.find_by(id: params[:id])
  end

  def purchase
    @order = Order.find_by(id: params[:id])
      address1 = params[:order][:mailing_address][:line1]
      address2 = params[:order][:mailing_address][:line2]
      @address = address1 + " " + address2
    if @order.update(order_params)
      flash[:result_text] = "Successfully Purchased!"
      flash[:status] = :success
      session[:order_id] = nil
      redirect_to invoice_path
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Fill in the blanks!"
      flash.now[:messages] = @order.errors.messages
      render :checkout, status: :bad_request
    end
  end

  def cancel
    @order = Order.find_by(id: session[:order_id])
    @order.products.each do |product|
      product.stock = product.original_stock
      product.save
    end

    @order.orderproducts.destroy_all
    session[:order_id] = nil
    @order.destroy
    redirect_to products_path
  end

  def invoice
    @order = Order.find_by(id: params[:id])
  end


#### Managing orders (Merchant side)

  def index
    @orderproducts = Orderproduct.where(product_id: params[:product_id])
    @orders = []
    @orderproducts.each do |orderproduct|
      order = Order.find_by(id: orderproduct.order_id)
      @orders << order
    end
  end

  def show
  end

  def update # update status (processing / shipped)

    @orderproduct.update(orderproduct_params)
    if @orderproduct.save
      flash[:result_text] = "Successfully Updated!"
      flash[:status] = :success
      redirect_to product_order_path(params[:product_id], params[:order_id])
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Select between processing and shipped!"
      flash.now[:messages] = @order.errors.messages
      render :product_order, status: :bad_request
    end
  end

  #### Checking order status (customer)

  def find
    order = Order.find_by(id: params[:order_id])
    if order.nil?
      flash.now[:status] = :failure
      flash.now[:result_text] = "Wrong order number!"
      render :find_order, status: :bad_request
    else
      flash[:result_text] = "Welcome #{order.cc_name}!"
      redirect_to view_order_path(id: params[:order_id])
    end
  end

  def view_order
    @product = Product.find_by(id: params[:id])
    @order = Order.find_by(id: params[:id])
    @orderproduct = Orderproduct.find_by(order_id: @order_id, product_id: @product_id)
  end

  private

  def order_params
    return params.require(:order).permit(:status, :cc_num, :cc_name, :order_email, :cc_expiry, :buyer_id, :cvv).merge(mailing_address: @address)
  end

  def orderproduct_params
    return params.require(:orderproduct).permit(:quantity, :product_id, :status).merge(order_id: @order.id)
  end

  def find_order
    @order = Order.find(session[:order_id])
    @product = Product.find_by(id: params[:product_id])
    @order = Order.find_by(id: session[:order_id])
  end

  def find_order_merchant
  @order = Order.find_by(id: params[:order_id])
  @product = Product.find_by(id: params[:product_id])
  @orderproduct = Orderproduct.find_by(order_id: @order.id, product_id: @product.id)
  end

end
