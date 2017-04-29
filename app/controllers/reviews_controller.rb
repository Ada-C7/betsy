class ReviewsController < ApplicationController

  def new
    @review = Review.new(params[:id])
  end

  def create
    @review = {
      product_id: params[:rider_id],
      review_description: review_params[:review_description],
      rating: review_params[:rating]
    }

    if @product.save
      flash[:status] = :success
      flash[:result_text] = "Thank you for your review!"
    else
      flash[:result_text] = "Invalid review"
      flash[:messages] = vote.errors.messages
      status = :conflict
    end
  end

  def index
    @reviews = Reviews.all
  end
end
