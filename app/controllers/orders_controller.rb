class OrdersController < ApplicationController


  def edit; end

  def create
    @order = Order.create
  end

  def edit; end

  def destroy; end

  def empty
    #session[:cart] = Order.new
  end


end
