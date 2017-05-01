class ReviewsController < ApplicationController

  def index
    @product_reviews = Review.where(product_id: params[:product_id])
  end

  def new
    @product_review = Review.new
    @product_review.product_id = params[:product_id]
  end

  def create
    @product_review = Review.new(review_params)
    @product_review.product_id = params[:product_id]
    if @product_review.save
      redirect_to product_path(@product_review.product_id)
    else
      render :new, status: :bad_request
      flash[:review_not_saved] = "Unable to save review"
    end
  end

  def show
    @product_review = Review.find_by(id: params[:id])
    if @product_review.nil?
      head :not_found
    end
  end

  def edit
    @product_review = Review.find_by(id: params[:id])
    if @product_review.nil?
      head :not_found
    end
  end

  def update
    @product_review = Review.find_by(id: params[:id])
    if @product_review.nil?
      head :not_found
    else
      @product_review.update_attributes(review_params)
      if @product_review.save
        redirect_to product_path(@product_review.product_id)
        flash[:messages] = "Review # #{@product_review.id} has been updated"
      else
        render :edit, status: :bad_request
      end
    end
  end

  def destroy
    @product_review = Review.find_by(id: params[:id])
    if @product_review.nil?
      head :not_found
    else
      @product_review.destroy
      redirect_to product_reviews_path
    end
  end

  private
  def review_params
    return params.require(:review).permit(:name, :rating, :comment, :product_id)
  end
end
