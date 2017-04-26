class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :destroy]
  # skip_before_action :require_login,  only: [:new, :edit, :destroy] # require specific user? or validate edits in model?

  def homepage
    # hide all retired products
      @products = Product.all
  end

  def browse_products
    if params[:search_term] == 'category'
      @products = Product.includes(:categories).where(categories: { id: params[:id] })
    elsif params[:search_term] == 'user'
      @products = Product.where(user: @merchant)
    end
  end

  def show; end

  def new
    @product = Product.new
  end

  def create
    @product = Product.create(product_params)
    if @product.save
      flash[:status] = :success
      flash[:result_text] = "Successfully added product"
      redirect_to :root
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Could not add product"
      flash.now[:messages] = @product.errors.messages
      render :new, status: :bad_request
    end
  end

  def edit; end

  def update
    @product.update(product_params)
    if @product.save
      flash[:status] = :success
      flash[:result_text] = "Successfully updated product"
      redirect_to :root
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Could not update product"
      flash.now[:messages] = @product.errors.messages
      render :edit, status: :bad_request
    end
  end

  def destroy
    @product.retired = true
    redirect_to :root
  end

  private

  def product_params
    params.require(:product).permit( :user_id, :name, :quantity, :price, :description, :image_url, category_ids:[])
  end

  def find_product
    @product = Product.find_by_id(params[:id])
    if !@product || @product.retired
      render_404
    end

    def user_from_url
      @merchant = User.find_by_id(params[:id])
    end
  end
end
