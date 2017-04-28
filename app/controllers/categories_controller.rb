class CategoriesController < ApplicationController
  def index
    all_categories = Category.all
    @categories = all_categories.find_all { |category| category.products != [] }
    @top_products = Product.highest_rated
    respond_to do |format|
      format.html
      format.csv { send_data all_categories.to_csv }
    end
  end

  def show
  end

  def new
    @category = Category.new
  end

  def create
    category = Category.new
    category.name = params[:category][:name]
    if category.save
        redirect_to user_path(current_user)
    end
  end
end
