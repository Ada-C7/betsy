class CategoriesController < ApplicationController


  def new
    @category = Category.new
  end


  def show
    @category = Category.find(params[:id])
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:status] = :success
      flash[:result_text] = "Successfluffy created #{@category.name} category!"
      redirect_to category_products_path(@category.id)
    else
      flash[:status] = :failure
      flash[:result_text] = 'Could not create category'
      flash[:messages] = @category.errors.messages
      render :new, status: :bad_request
    end

  end

  private

  def category_params
    params.require(:category).permit(:name)
  end


end
