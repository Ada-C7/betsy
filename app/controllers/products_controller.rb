class ProductsController < ApplicationController
# before_action :require_correct_user, only: [:edit, :update, :retire]
  def index
    if params[:search] # for search form
      @products = Product.search(params[:search]).order("name DESC")
    elsif params[:merchant_id]
      # localhost:3000/merchants/2/products
      # we are in the nested route
      # retrieve products based on the merchant
      @products = Merchant.find(params[:merchant_id]).products
    else
      #localhost:3000/products
      # we are in our 'regular' route
      @products = Product.all
    end
  end

    def top_products
      @top_products = Product.highest_rated
    end

  def new
    @merchant = Merchant.find_by(id: params[:merchant_id])
    if @merchant.nil?
      flash[:message] = "Could not find that merchant"
      redirect_to products_path
      return
    end
    @product = @merchant.products.build
  end

  def create
    @merchant = Merchant.find_by(id: params[:merchant_id])
    if @merchant.nil?
      flash[:message] = "Could not find that merchant"
      redirect_to products_path
      return
    end
    @product = @merchant.products.build(product_params)
    if @product.save
      flash[:message] = "Woot! Successfully created the new item: #{@product.name}"
      redirect_to merchant_path(@merchant)
    else
      flash[:message] = "BooHoo. Unable to create new item."
      #flash[:messages] = @product.errors.messages
      render :new, status: :bad_request
      #redirect_to merchant_path(@merchant)
    end
  end

  def show
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      flash[:message] = "Could not find that product"
      redirect_to products_path
    elsif @product.retired == true && session[:user_id] != @product.merchant.id
      flash[:message] = "You cannot view retired products"
      redirect_to products_path
    end
    @order_product = OrderProduct.new
    @review = Review.new
  end

  def edit
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      flash[:message] = "Could not find that product"
      redirect_to products_path
      return
    end
    @merchant = @product.merchant
  end

  def update
    @product  = Product.find_by(id: params[:id])
    if @product.nil?
      flash[:message] = "Could not find that product"
      redirect_to products_path
      return
    else
      @merchant = @product.merchant
      @product.update_attributes(product_params)
      if @product.save
        redirect_to product_path(@product)
      else
        flash[:message] = "Bad News. Unable to update item."
        render :edit, status: :bad_request
      end
    end
  end

  def retire
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      flash[:message] = "Could not find that product"
      redirect_to products_path
      return
    end
    if @product.retired == true
      @product.retired = false
    else
      @product.retired = true
    end
    @product.save
    redirect_to product_path(@product)
  end


  # def destroy
  #   @product = Product.find_by(id: params[:id])
  #   if @product.nil?
  #     flash[:message] = "Could not find that product"
  #     redirect_to products_path
  #     return
  #   end
  #   if @product.destroy
  #     redirect_to products_path
  #   end
  # end
  #

  private
  def product_params
    params.require(:product).permit(:name, :price, :photo_url, :description, :stock, :merchant_id, category_ids:[])
  end
end
