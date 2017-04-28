class OrdersController < ApplicationController
  before_action :check_login, only: [:index, :complete, :incomplete, :show]
  helper_method :user_orders, :user_orders_items

  def index
    @orders = Order.all.order(id: :desc)
    params[:order_status] ||= nil
    # params[:order_status] = order_status

    # @user_orders = current_user.user_orders if params[:status] == "all"



    # respond_to do |format|
    #   format.html
    #   format.csv { send_data @orders.to_csv }
    # end
  end

  def complete; end

  def incomplete;end

  def checkout
    @order = Order.find_by_id(session[:order_id])
    if @order.nil? || @order.order_items == []
      flash[:failure] = "Please add an item to your cart to check out"
      redirect_to root_path
    end
    @user = User.find_by_id(session[:user_id])
    if @user != nil
      @order.email = @user.email
    end
  end

  def update #place order
    @order = Order.find_by_id(session[:order_id])
    if @order.nil?
      flash[:error] = "There was no order to find"
      redirect_to :root
    else
      @order.status = "paid"
      if @order.update(order_params)
        session[:order_id] = nil
        @order.order_items.each do |item|
          #updates the stock of each of the products
          item.product.stock = item.product.stock - item.quantity
          item.product.save
        end
        # redirect_to confirmation_path(@order.id)
      else
        flash[:error] = "Could not place order"
        redirect_to :cart
      end
    end
  end

  def show
    @order = Order.find(params[:id])
  end


  private

  def check_login
    if !current_user
      flash[:error] = "You must be the owner to access that page"
      redirect_to :root
    end
  end

  def order_params
    params.require(:order).permit(:email, :name_on_cc, :cc_number, :cc_ccv, :billing_zip, :address)
  end


end
