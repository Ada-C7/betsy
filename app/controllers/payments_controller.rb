class PaymentsController < ApplicationController
  skip_before_action :require_login
  def new; end

  def payment_confirmation
    @order = current_order
    @orderitems = current_order.orderitems
  end

  def update
    order = Order.find_by_id(params[:order][:order_id])

    order.status = "paid"
    order.email = params[:order][:email]
    order.address = params[:order][:address]
    order.cc_num = params[:order][:cc_num]
    order.cc_expiry = params[:order][:cc_expiry]
    order.cc_security = params[:order][:cc_security]
    order.zip = params[:order][:zip]

    if order.save
      flash[:success] = "We have received your payment. Thank you for your order!"
      redirect_to payment_confirmation_path
    else
      flash[:test] = "#{order.errors}"
      flash.now[:error] = "Error has occurred"
      render "new"
    end
  end

end
