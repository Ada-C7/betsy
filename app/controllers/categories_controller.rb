class CategoriesController < ApplicationController

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:status] = :success
      flash[:result_text] = "Successfully created #{@category.name}"
      redirect_to categories_path
    else
      flash[:status] = :failure
      flash[:result_text] = "Could not create #{@category.name}"
      flash[:messages] = @category.errors.messages
      render :new, status: :bad_request
    end
  end

  def show
    @category = Category.find_by(id: params[:id])
    if @category.nil?
      return redirect_to categories_path, status: :not_found
    end
    @products = @category.products
  end
end


private
def category_params
  params.require(:category).permit(:name)
end
