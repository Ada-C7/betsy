class CategoriesController < ApplicationController
  before_action :require_login, except:[:index]

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    p "we are at the right method!"
    @category = Category.new(category_params)
    if @category.save
      flash[:status] = :success
      flash[:result_text] = "Successfully created the new category #{@category.name}"
      redirect_to categories_path
    else
      # flash[:status] = :failure
      # flash[:result_text] = "Could not create #{@category.name}"
      # flash[:messages] = @category.errors.messages
      render :new , status: :bad_request
    end
  end

  private
  def category_params
    params.require(:category).permit(:name)
  end
end
