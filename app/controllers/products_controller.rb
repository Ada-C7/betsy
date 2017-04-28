class ProductsController < ApplicationController
  before_action :check_login, only: [:new]

  def index
    if params[:category_id]
      category = Category.find_by(id: params[:category_id])
      @products = category.products.where(selling_status: true)
      @category_name = category.name.capitalize
    elsif params[:user_id]
      user = User.find_by(id: params[:user_id])
      @products = user.products.where(selling_status: true)
      @category_name = user.username.capitalize
      @profile = user.profile
    else
      @products = Product.where(selling_status: true)
      @category_name = "All Products"
    end
    # respond_to do |format|
    #   format.html
    #   format.csv { send_data @products.to_csv }
    # end
  end

  def show
    @product = Product.find_by_id(params[:id])
    if !@product
      render_404
    end
    @item = OrderItem.new
  end


  def new
    @product = Product.new
    @category = Category.new
  end


  def create
    @product = Product.create(product_params)
    @product.user_id = current_user.id
    # byebug
    if @product.save
      flash[:success] = "#{@product.name} successfully added!"
      redirect_to products_path
    else
      flash[:failure] = "Something went wrong"
      render "new"
    end
  end

  def edit
    @product = Product.find_by_id(params[:id])
  end

  def update
    @product = Product.find_by_id(params[:id])
    if @product.update(product_params)
      flash[:success] = "#{@product.name} successfully edited"
      redirect_to product_path(@product.id)
    else
      flash.now[:error] = "Something went wrong..."
      render "edit"
    end
  end

  def status
    @product = Product.find_by_id(params[:id])
    if @product.selling_status == true
      @product.selling_status = false
    else
      @product.selling_status = true
    end
    if @product.save
      flash[:success] = "Successfully changed item status"
      redirect_to user_path(current_user.id)
    end
  end

  private

  def check_login
    if !current_user
      flash[:error] = "You must be logged in to create a new product"
      redirect_to :root
    end
  end

  def product_params
    params.require(:product).permit(:name, :description, :stock, :price, :photo_url, :selling_status, category_ids: [])
  end

end
