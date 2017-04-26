class VendorsController < ApplicationController
  before_action :find_vendor, except: [:index]
  before_action :find_orderitems, except: [:index, :show, :edit, :update]
  before_action :tally_earnings, except: [:index, :show, :edit, :update]
  before_action :tally_count, except: [:index, :show, :edit, :update]
  before_action :render_orderitems, except: [:index, :show, :fulfillment, :edit, :update]

  def index
    @vendors = Vendor.all
  end

  def show; end

  def edit; end

  def update

  end

  def fulfillment; end

  def fulfillment_pending; end

  def fulfillment_paid; end

  def fulfillment_shipped; end

  def fulfillment_cancelled; end

  private

  def tally_earnings
     price = @order_items.where('status = ? OR status = ?', 'Paid', 'Shipped').sum('price')
     quantity = @order_items.where('status = ? OR status = ?', 'Paid', 'Shipped').sum('quantity')
     @total_earnings = price * quantity

     price = @order_items.where('status = ?', 'Pending').sum('price')
     quantity = @order_items.where('status = ?', 'Pending').sum('quantity')
     @pending_earnings = price * quantity

     price = @order_items.where('status = ?', 'Paid').sum('price')
     quantity = @order_items.where('status = ?', 'Paid').sum('quantity')
     @paid_earnings = price * quantity

     price = @order_items.where('status = ?', 'Shipped').sum('price')
     quantity = @order_items.where('status = ?', 'Shipped').sum('quantity')
     @shipped_earnings = price * quantity

     price = @order_items.where('status = ?', 'Cancelled').sum('price')
     quantity = @order_items.where('status = ?', 'Cancelled').sum('quantity')
     @cancelled_earnings = price * quantity
  end

  def tally_count
     @total_count = @order_items.where('status = ? OR status = ?', 'Paid', 'Shipped').count
     @pending_count = @order_items.where(status: 'Pending').count
     @paid_count = @order_items.where(status: 'Paid').count
     @shipped_count = @order_items.where(status: 'Shipped').count
     @cancelled_count = @order_items.where(status: 'Cancelled').count
  end

  def render_orderitems
     @order_items = @vendor.orderitems
     render "fulfillment"
  end

  def find_orderitems
   @order_items = @vendor.orderitems
  end

  def find_vendor
    @vendor = Vendor.find_by_id(params[:id])
    render_404 if !@vendor
  end
end
