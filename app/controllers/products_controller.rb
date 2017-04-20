class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update]
  # skip_before_action :require_login,  only: [:new, :edit, :destroy] # require specific user? or validate edits in model?

  def homepage
    # products_by_categories =
    # products_by_users =
    # spotlight products
  end

  def index
    if params[:category_id]
      @products = Product.includes(:categories).where(categories: {id: params[:category_id]})
    # do it this way?
    # elsif products belong to users
      # @products = Product.where(user_id: params[:user_id])
    else
      @products = Product.all
    end
  end

  def show
    if !@product
      render_404
    end
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.create(product_params)
    if @product.save
      flash[:success] = "New product added"
      redirect_to products_path
    else
      flash.now[:error] = "Failed to add product"
      render "new"
    end
  end

  def edit; end

  def update
    @product.update(product_params)
  end

  def destroy
    Product.destroy(params[:id])
    redirect_to products_path
  end

  private

  def product_params
    params.require(:product).permit( :user_id, :name, :quantity, :price, :description, :image_url )
  end
end
