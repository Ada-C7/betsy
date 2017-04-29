class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :edit, :update, :destroy]


  def index
    @reviews = Review.all
  end


  def create

     @review = Review.new(review_params)
     @review.product_id = params[:product_id]
    if @review.save
      ;flash[:notice] = 'Review was successfully created.'
      redirect_to product_path(@review.product.id)

    else
      flash[:notice] = "Error creating review"
      redirect_to product_path(@review.product.id)

    end
  end

  def edit
    @review = Review.find(params[:id])
  end

  def update
    @review = Review.find(params[:id])
  end

  def new
    @review = Review.new
  end


  def show
    @review = Review.find_by_id(params[:id].to_i)
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy
    redirect_to products_path
  end

  private
  def review_params
    return params.require(:review).permit(:rating, :comment)
  end
end
