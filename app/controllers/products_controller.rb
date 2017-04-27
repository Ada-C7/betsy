class ProductsController < ApplicationController
  # before_action :find_user
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
      # flash[:status] = :success
      # flash[:result_text] = "Successfully created #{@product.id}"
      redirect_to products_path
    else
      # flash[:status] = :failure
      # flash[:result_text] = "Could not create #{@product.id}"
      # flash[:messages] = @product.errors.messages
      render :new #, status: :bad_request
    end
  end

  def show
    @product = Product.find_by(id: params[:id])
    if !@product.nil?
      session[:product_id] ||= @product.id
    end
    # @login_merchant = Product.find_by(id: 1).merchant # Must be removed when right code for @login_merchant is added to the ApplicationController
    if @product.nil?
      head :not_found
    end
  end

  def edit
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      head :not_found
    end
  end

  def update
    product = Product.find_by(id: params[:id])
    product.update_attributes(product_params)
    product.save
    redirect_to product_path(product)
  end

  def status
    product = Product.find_by(id: params[:id])
    # merchant = Merchant.find_by(id: params[:id])
    product.status_change
    redirect_back(fallback_location: root_path)
  end

  def new_category
    @product = Product.find_by(id: params[:product_id])
    @categories = Category.all
  end

  def create_category
    Product.find_by(id: params[:product_id]).categories << Category.find_by(id: params[:category_id])
    redirect_to product_path(Product.find_by(id: params[:product_id]))
  end



  private
  def product_params
    params.require(:product).permit(:name, :price, :inventory, :image, :category, :status, :description)
  end

  # def find_user
  #   # @login_merchant = Product.find_by(id: 1).merchant
  #   if session[:merchant_id]
  #       @login_merchant = Merchant.find_by(id: session[:merchant_id])
  #   end
  # end

  def destroy_session_product_id
    session.delete(:product_id)
  end


end # END of class ProductsController
