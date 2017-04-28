require "test_helper"

describe ReviewsController do

  # describe "new" do
  # it "succeeds for a real product" do
  #     product = products(:owl1)
  #     get product_path(product.id)
  #     must_respond_with :success
  #   end
  # end

  describe "create" do
    it "creates a new review for the given product" do
      product = Product.first
      start_count = product.reviews.count

      review_data = {
        review: {
          rating: 2,
          review_text: "good",
          product_id: product.id
        }
      }
      post reviews_path, params: review_data
      must_redirect_to product_path(product)

      end_count = Product.first.reviews.count
      end_count.must_equal start_count + 1

      review = Review.last
      review.rating.must_equal review_data[:review][:rating]
    end
    it "doesn't create a new review for the bad data" do
      product = Product.first
      start_count = product.reviews.count

      review_data = {
        review: {

          review_text: "good",
          product_id: product.id
        }
      }
      post reviews_path, params: review_data

      end_count = Product.first.reviews.count
      end_count.must_equal start_count

    end
  end
end
