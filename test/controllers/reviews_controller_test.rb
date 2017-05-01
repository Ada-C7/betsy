require "test_helper"

describe ReviewsController do

  describe "index" do

    it "is successful when there are many reviews" do
      Review.count.must_be :>, 0
      get product_reviews_path(product_id: 1)
      must_respond_with :success
    end

    it "is successful when there are zero reviews" do
      Review.destroy_all
      get product_reviews_path(product_id: 2)
      must_respond_with :success
    end

  end

  describe "new" do
    it "runs successfully" do
      product = Product.first
      get new_product_review_path(product)
      must_respond_with :success
    end

    # it "returns 404 for a product_id that does not exist" do
    #   product = Product.last + 1
    #   get new_product_review_path(product)
    #   must_respond_with :not_found
    # end
  end

  describe "create" do
    it "creates a new review" do
      product = Product.first
      start_count = Review.count
      review_data = {
        review: {
          id: 1,
          rating: 1,
          product_id: 1
        }
      }
      post product_reviews_path(product), params: review_data
      must_redirect_to product_path(product)

      end_count = Review.count
      end_count.must_equal start_count + 1

      review = Review.last
      review.rating.must_equal review_data[:review] [:rating]
    end

    it "responds with bad_request for icky data" do
      start_count = Review.count
      review = reviews(:one)
      review_data = {
        review: {
          blah: -6
        }
      }

      post product_reviews_path(product_id: review.product_id, id: review.id), params: review_data
      must_respond_with :bad_request

      end_count = Review.count
      end_count.must_equal start_count
    end
  end

  describe "show" do
    it "finds a review that exists" do
      review = reviews(:one)
      get product_review_path(product_id: review.product_id, id: review.id)
      must_respond_with :success
    end

    it "returns 404 for a classroom that does not exist" do
      get product_review_path(product_id: 9999, id: 9999)
      must_respond_with :not_found
    end
  end

  describe "edit" do

    it "finds a review that exists" do
      review = reviews(:one)
      get edit_product_review_path(product_id: review.product_id, id: review.id)
      must_respond_with :success
    end

    it "returns 404 for a review that does not exist" do
      get edit_product_review_path(product_id: 9999, id: 9999)
      must_respond_with :not_found
    end
  end

  describe "update" do

    it "updates the review" do
      review = reviews(:one)
      review_data = {
        review: {
          name: "sahana"
        }
      }
      patch product_review_path(product_id: review.product_id, id: review.id), params: review_data
      must_redirect_to product_path(review.product_id)
      review.reload
      review.name.must_equal review_data[:review][:name]
    end

    it "responds with bad_request for icky data" do
      review = reviews(:one)
      review_data = {
        review: {
          rating: 0
        }
      }
      patch product_review_path(product_id: review.product_id, id: review.id), params: review_data
      must_respond_with :bad_request
      review.rating.must_equal review.rating
    end

    it "returns 404 for a review that does not exist" do
      patch product_review_path(product_id: 9999, id: 9999)
      must_respond_with :not_found
    end

  end

  describe "destroy" do
    it "destroys a review that exists" do
      start_count = Review.count
      review = reviews(:one)
      delete product_review_path(product_id: review.product_id, id: review.id)
      must_redirect_to product_reviews_path
      end_count = Review.count
      end_count.must_equal start_count - 1
    end

    it "returns 404 for a review that DNE" do
      start_count = Review.count
      delete product_review_path(product_id: 9999, id: 9999)
      must_respond_with :not_found
      end_count = Review.count
      end_count.must_equal start_count
    end
  end
end
