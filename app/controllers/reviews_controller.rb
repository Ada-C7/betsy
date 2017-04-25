class ReviewsController < ApplicationController
  def new
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    @review.product_id = session[:product_id]
    if @review.save
      # flash[:status] = :success
      # flash[:result_text] = "Successfully created #{@product.id}"
      redirect_to product_path(session[:product_id])
    else
      # flash[:status] = :failure
      # flash[:result_text] = "Could not create #{@product.id}"
      # flash[:messages] = @product.errors.messages
      render :new #, status: :bad_request
    end
  end

  private
  def review_params
    params.require(:review).permit(:rating, :review)
  end
end
