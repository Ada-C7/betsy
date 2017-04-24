class ReviewsController < ApplicationController
  def index
    @reviews = Review.all
  end

  def new
    @product = Product.find(params[:product_id])
    @review = Review.new
    # @review = @product.reviews.new

    # if session[:user_id] == @product.vendor_id
    # flash to ensure vendors cannot review own products
    # redirect to specific product page
  end

  def create
  #need to link review to product somehow
    @review = Review.new(review_params)
    @product = Product.find(params[:product_id])
    @review.product_id = @product.id
     #this will link product to review method, is this the best way??
    # Merchant cannot review own product

    if @review.save
      redirect_to product_path(@product.id)
    else
      render :new
    end
  end


  private


  def reviews_params
    params.require(:review).permit(:product_id, :rating, :comment)
  end
end
