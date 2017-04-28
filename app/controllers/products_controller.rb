class ProductsController < ApplicationController

  def index
    # product.retired || product.inventory = 0
    @category = params[:category]
    @products = Product.in_stock(@category)
  end

  def show
    @product = Product.find_by(id: params[:id])
  end

  def new
    @product = Product.new()
    @merchant_id = session[:user_id]
  end

  def create
    @product = Product.new(product_params)
    # @product.retired = false


    if @product.save
      redirect_to products_path
    else
      render :new, status: :bad_request
    end
  end

  def edit
    @product = Product.find_by(id: params[:id])

    if @product.nil?
      head :not_found
    end
  end

  def update
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      head :not_found
    else
      @product.update_attributes(product_params)
      if @product.save
        redirect_to product_path(@product.id)
      else
        render :edit, status: :bad_request
      end
    end
  end

  def destroy
    #product is removed from the list so users cannot see it, only merchant can
    @product = Product.find_by(id: params[:id])
      if @product.nil?
        head :not_found
      else
        @product.retired = true
        if @product.save
          redirect_to product_path(@product.id)
        else
          flash.now[:status] = :failure
          flash.now[:result_text] = "You could not retire this product"
        end
      end
  end

  private
  def product_params
    return params.require(:product).permit(:name, :price, :category, :description, :inventory, :photo_url, :retired)
  end
end
