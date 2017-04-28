class ReviewsController < ApplicationController

  # def new
  #   @product = Product.find_by(id: params[:id])
  #   @review = Review.new
  # end

  def create
    @review = Review.new(review_params)
    if @review.save
      redirect_to product_path(@review.product_id)
    else
      flash[:failure] = "Enter review text and rating"
      redirect_to product_path(@review.product.id)
    end
  end
end

private
def review_params
  params.require(:review).permit(:rating, :review_text, :product_id)
end
