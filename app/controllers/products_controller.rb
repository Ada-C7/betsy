class ProductsController < ApplicationController
  before_action :require_login, only: [:new, :edit, :update, :destroy]

  def index
    @products = Product.all
  end

  def show
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      head :not_found
    end

    @orderproduct = Orderproduct.new
    @review = Review.new
    @review_list = Review.where(product_id: params[:id])
  end

  def new
    @product = Product.new
  end

  def create

    @product = Product.new(product_params)
    # {
    #   merchant_id :merchant_id
    #   :
    # }


    if @product.photo_url = ""
      @product.photo_url = "http://www.rawdogplus.com/wp-content/uploads/2015/05/pic-coming-soon_150x150.jpg"
      @product.save
    end

    if @product.save
      flash[:status] = :success
      flash[:result_text] = "Successfully added #{@product.product_name} to inventory"
      redirect_to products_path
    else
      flash[:status] = :failure
      flash[:result_text] = "Could not create #{@product.product_name}"
      flash[:messages] = @product.errors.messages
      render :new, status: :bad_request
    end
  end

  def edit
    @product = Product.find_by(id: params[:id])
  end

  def update
    @product = Product.find_by(id: params[:id])
    @product.update_attributes(product_params)

    if @product.save
      flash[:status] = :success
      flash[:result_text] = "Successfully updated #{@product.product_name}"
      redirect_to products_path
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Could not update #{@product.product_name}"
      flash.now[:messages] = @product.errors.messages
      render :edit, status: :not_found
    end
  end

  def destroy
    product = Product.find(params[:id])
    product.destroy
    redirect_to merchant_path(id: product.merchant.id)
  end

  def review
    flash[:status] = :failure
    product = Product.find_by(id: params[:id])
    if @current_user.nil? || @current_user.id != product.merchant_id
      review_info = {
        product_id: product.id,
        rating: review_params[:rating],
        nickname: review_params[:nickname],
        review_description: review_params[:review_description]
      }
      @review = Review.new(review_info)
      if @review.save
        flash[:status] = :success
        flash[:result_text] = "Successfully reviewed!"
        redirect_to product_path(product.id)
      else
        flash[:result_text] = "Could not review"
        flash[:messages] = review.errors.messages
        render :new
      end
    else
      flash[:result_text] = "You cannot review your own product."
      redirect_to product_path(product.id)
    end
  end

  private
  def product_params
    params.require(:product).permit(:product_name, :price, :merchant_id, :photo_url, :stock, :product_description)
  end

  def review_params
    params.require(:review).permit(:rating, :nickname, :review_description)
  end
end
