require "test_helper"

describe ReviewsController do
  describe "new" do
    it "succeeds" do
      get new_review_path
      must_respond_with :success
    end
  end # END of describe "new"


  describe "create" do
    it "creates a review with valid data" do
      start_count = Review.count
      puts start_count
      review_data = {
        review: {
          rating: 3,
        }
      }
      get product_path(products(:product1))
      post reviews_path , params: review_data
      must_redirect_to product_path(products(:product1))
      Review.count.must_equal start_count + 1
      end
    end   # END of describe "create"
end # END of describe ReviewsController
