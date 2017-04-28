class CategoriesController < ApplicationController
  #don't need to be logged in to see the list of categories through index, but we do want to restrict the ability to create categories to logged in users only
  skip_before_action :require_login, only: [:index]

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.create category_params

    unless @category.id == nil
      flash[:success] = "#{@category.name} successfully created"
      redirect_to categories_path
    else
      flash.now[:error] = "Category not created; see below for specifics"
      render "new"
    end
  end

  def show; end

  private

  def category_params
    params.require(:category).permit(:name)
  end

end
