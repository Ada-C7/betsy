class OrderItemsController < ApplicationController
  skip_before_action :require_login

  def create

    #i think this logic is checking to see if you have an Orderitem of this Product type already associated with this Order
    if Orderitem.where(:order_id => current_order).length != 0 && Orderitem.where(:product_id => params[:order_items][:product_id]).length != 0

      flash[:error] = "This item is already in your cart"

    #checking to see if product is in stock (the way the view works this is not really necessary but maybe there is some workaround b/c users always figure out that shit )
    #the product_id and the quantity we want to check for the orderitem is coming through this nested hash b/c from the 'form_for :order_items' on the products show page
    elsif Product.in_stock(params[:order_items][:product_id], params[:order_items][:quantity])
      @orderitem = Orderitem.new
      @orderitem.product_id = params[:order_items][:product_id]
      @orderitem.quantity = params[:order_items][:quantity]
      @orderitem.order_id = current_order.id
      @orderitem.save
      flash[:success] = "Item added to cart"
    else
      flash[:error] = "Not enough product in stock"
    end
      redirect_to product_path(params[:order_items][:product_id])
  end

  def update
    #change qty of item
    @orderitem = Orderitem.find_by_id(params[:id])

    if @orderitem.update orderitem_params
      redirect_to carts_show_path
    else
      flash[:error] = "Could not update cart"
    end
  end

  def destroy
    Orderitem.destroy(params[:id])
    redirect_to carts_show_path
  end

  #we will need a method to get order items by order

  #we will need a method to get order items by Merchant (the person who is selling the product)

  private

  def orderitem_params
    params.require(:orderitem).permit(:quantity, :product_id)

  end

end
