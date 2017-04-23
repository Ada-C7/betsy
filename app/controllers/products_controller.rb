class ProductsController < ApplicationController
  before_action :find_user

  def root
    @products = Product.all
  end

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    @product.merchant_id = @login_user.id
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
    # @login_user = Product.find_by(id: 1).merchant # Must be removed when right code for @login_user is added to the ApplicationController
  end

  private
  def product_params
    params.require(:product).permit(:name, :price, :inventory, :image, :category, :status, :description)
  end

  def find_user
    @login_user = Product.find_by(id: 1).merchant
    # if session[:user_id]
    #   @login_user = User.find_by(id: session[:user_id])
    # end
  end



end # END of class ProductsController
