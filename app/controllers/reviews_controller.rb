class ReviewsController < ApplicationController
    # def index
    #   @reviews = Review.all
    #   respond_to do |format|
    #     format.html
    #     format.csv { send_data @reviews.to_csv }
    #   end
    # end

    def new
        @review = Review.new
    end

    def create
        @review = Review.new
        @review.title = params[:review][:title]
        @review.rating = params[:review][:rating]
        @review.product_id = params[:product_id]
        @review.review_text = params[:review][:review_text]
        if @review.save
            redirect_to product_path(params[:product_id])
        else
            render 'new'
        end
    end
end
