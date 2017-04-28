class CategoriesController < ApplicationController
  before_action :require_login, except:[:index]

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      # flash[:status] = :success
      # flash[:result_text] = "Successfully created #{@product.id}"
      redirect_to categories_path
    else
      # flash[:status] = :failure
      # flash[:result_text] = "Could not create #{@product.id}"
      # flash[:messages] = @product.errors.messages
      render :new #, status: :bad_request
    end
  end

  private
  def category_params
    params.require(:category).permit(:name)
  end
end
