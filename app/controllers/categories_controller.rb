class CategoriesController < ApplicationController

  # def index
  #   @categories = Category.all
  # end

  def new
    @category = Category.new
  end

  def create
    @category = Category.create(name: params[:category][:name])
    if @category.save
      flash[:success] = "New category added"
      redirect_to :root
    else
      flash.now[:error] = "Failed to add category"
      render "new"
    end
  end

end
