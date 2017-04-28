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

<<<<<<< HEAD
# ANNA Already fixed this.
  # def create_category #GIVE THIS TESTS. Then look at validating quantity for product orders wrote custom method for that validation. Make sure category is UNIQUE in validation. then clean up if/elsif
  #   category = Category.find_by(id: params[:category_id])
  #   product = Product.find_by(id: params[:product_id])
  #
  #   if product.categories.include?(category) #THIS BLOCK IS UNIQUENESS
  #     flash[:status] = :failure
  #     flash[:result_text] = "This product is already part of that category"
  #     redirect_back(fallback_location: root_path)
  #   elsif category
  #     product.categories << category
  #     redirect_to product_path(Product.find_by(id: params[:product_id]))
  #   else
  #     flash[:status] = :failure
  #     flash[:result_text] = "You did not choose a category"
  #     redirect_back(fallback_location: root_path)
  #   end
  # end
=======
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
>>>>>>> 3da0570be526f2b54d6e328b4853a35bba02166a

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
