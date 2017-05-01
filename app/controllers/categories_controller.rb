class CategoriesController < ApplicationController

  def index
    @categories = Category.all
  end

  

  def new
    @category = Category.new
  end

  def create

    @category = Category.create(category_params)
    if @category.save
      redirect_to categories_path
      flash[:messsage] = "#{@category.name.capitalize} was successfully added to the category list"
    else
      render :new, status: :bad_request
      flash[:failure] = "Could not add your category"
      flash[:messages] = @category.errors.messages
    end
  end


  def destroy
    @category = Category.find_by(id:params[:id])
    @category.destroy
    redirect_to categories_path
  end
  private
  def category_params
    return params.require(:category).permit(:name, :img_url )
  end


end
