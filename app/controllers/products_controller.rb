class ProductsController < ApplicationController

  def root
  end

  def index
    @products = Product.all
  end

  def show
    @product = Product.find_by(id: params[:id])
  end

end
