class OrderItemsController < ApplicationController
  before_action :create_order, only: [:create]
  helper_method :duplicate_item?

  # commenting out for test coverage
  # def index
  #   @order_items = OrderItem.all
  #   respond_to do |format|
  #     format.html
  #     format.csv { send_data @order_items.to_csv }
  #   end
  # end

  def create
    if !duplicate_item?
      @item = OrderItem.new
      @item.quantity = item_params[:quantity].to_i
      @item.product_id = params[:id]
      @item.order_id = @order.id
      if @item.save
        @order.order_items << @item
        redirect_to cart_path
      else
        flash.now[:failure] = "Unable to add to cart at this time"
        redirect_to product_path(params[:id])
      end
    else
      @items = OrderItem.where(order_id: session[:order_id])
      @item = @items.find_by(product_id: params[:id])
      if @item.quantity + item_params[:quantity].to_i > @item.product.stock
        flash[:failure] = "Not enough items in inventory to add #{@item.quantity} to your cart!"
        redirect_to product_path(params[:id])
      else
        @item.quantity += item_params[:quantity].to_i
        # raise
        if @item.save
          flash[:success] = "Added #{item_params[:quantity]} to existing order for #{@item.product.name}"
          redirect_to cart_path
        else
          flash.now[:failure] = "Sorry, something went wrong"
          redirect_to :back
        end
      end
    end
  end

  def cart
    @cart_items = OrderItem.where(order_id: session[:order_id])
    @item = OrderItem.find_by_id(params[:id])
    # raise
  end

  def update
    @item = OrderItem.find_by_id(params[:id])
    @order = Order.find_by_id(@item.order_id)

    if item_params[:quantity].to_i <= @item.product.stock
      if @item.update(item_params)
        # raise
        flash.now[:success] = "Quantity of #{@item.product.name} successfully updated"
        ##check if all shipped method
        if @order.status != 'pending'
          @order = @item.check_order_status(@item.order_id)
          redirect_to user_orders_path(session[:user_id])
        else
          redirect_to :cart
        end
      else
        flash.now[:error] = "Unable to update quantity of #{@item.product.name} at this time"
        render :cart
      end
    else
      redirect_to :cart
    end
  end

  def destroy
    @item = OrderItem.find_by_id(params[:id])
    if @item.destroy
      flash[:success] = "Removed #{@item.product.name} from cart"
      redirect_to :cart
    else
      flash.now[:failure] = "Could not remove #{@item.product.name} from cart at this time. Whoops!"
      render :cart
    end
  end

  private

  def item_params
    params.require(:order_item).permit(:quantity, :ship_status)
  end

  def create_order
    if session[:order_id]
      @order = Order.find_by_id(session[:order_id])
    elsif current_user
      current_order = Order.find_by(status: "pending", email: current_user.email)
      if current_order
        session[:order_id] = current_order.id
      else
        @order = Order.create
        session[:order_id] = @order.id
      end
    else
      @order = Order.create
      session[:order_id] = @order.id
    end
  end

  def duplicate_item?
    if session[:order_id]
      if !OrderItem.where(order_id: session[:order_id]).empty?
        items = OrderItem.where(order_id: session[:order_id])
        if items.find_by(product_id: params[:id])
          return true
        else
          return false
        end
      else
        return false
      end
    end
  end
end
