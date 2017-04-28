class ProductsController < ApplicationController
  # before_action :find_user
  before_action :require_login, except:[:root, :index, :show]
  before_action :destroy_session_product_id

  def root
    @products = Product.where(status: "active")
  end

  def index
    if params[:category_id]
      # @products = Product.include(:categories).where(categories: {id: params[:category_id]})
      @products = Category.find(params[:category_id]).products.where(status: "active")
      @category = Category.find(params[:category_id])
    else
      @products = Product.where(status: "active")
    end
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    @product.status = "passive"
    @product.check_image
    @product.merchant_id = @login_merchant.id
    if @product.save
      flash[:status] = :success
      flash[:result_text] = "Successfully created the product #{@product.name}"
      redirect_to merchant_path(@login_merchant)
    else
      flash[:status] = :failure
      flash[:result_text] = "Something went wrong"
      flash[:messages] = @product.errors.messages
      redirect_to new_product_path
      # render :new #, status: :bad_request
    end
  end

  def show
    @product = Product.find_by(id: params[:id])
    if !@product.nil?
      session[:product_id] ||= @product.id
    end

    if @product.nil?
      flash[:status] = :failure
      flash[:result_text] = "Product Not Found"
      redirect_to products_path
    end
  end

  def edit
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      flash[:status] = :failure
      flash[:result_text] = "Product Not Found"
      redirect_to products_path
    end
  end

  def update
    product = Product.find_by(id: params[:id])
    product.update_attributes(product_params)
    # product.save
    # redirect_to product_path(product)
    if product.save
      flash[:status] = :success
      flash[:result_text] = "Successfully updated #{product.name}"
      redirect_to product_path(product)
    else
      flash[:status] = :failure
      flash[:result_text] = "Could not update #{product.name}"
      flash[:messages] = product.errors.messages
      redirect_to edit_product_path(product)
    end
  end

  def status
    product = Product.find_by(id: params[:id])
    product.status_change
    redirect_back(fallback_location: root_path)
  end

  def new_category
    @product = Product.find_by(id: params[:product_id])
    @categories = Category.all
  end

  def create_category
    if !Product.find_by(id: params[:product_id]).categories.include? Category.find_by(id: params[:category_id])
      Product.find_by(id: params[:product_id]).categories << Category.find_by(id: params[:category_id])
      flash[:status] = :success
      flash[:result_text] = "Category successfully added"
      redirect_to product_path(Product.find_by(id: params[:product_id]))
    else
      flash[:status] = :failure
      flash[:result_text] = "The category #{Category.find_by(id: params[:category_id]).name} is already added to this product"
      # flash[:messages] = @product.errors.messages
      redirect_to product_new_category_path(Product.find_by(id: params[:product_id]))
    end
  end

  private
  def product_params
    params.require(:product).permit(:name, :price, :inventory, :image, :category, :status, :description)
  end

  def destroy_session_product_id
    session.delete(:product_id)
  end


end # END of class ProductsController
