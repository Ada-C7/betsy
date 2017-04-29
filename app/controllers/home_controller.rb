class HomeController < ApplicationController

  def index
    @categories = Category.all
    if params[:category_id]
      @products = Product.includes(:product_categories).where(product_categories: { category_id: params[:category_id] })
    else
      @products = Product.all
    end
  end
end
