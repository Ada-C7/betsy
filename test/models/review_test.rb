require "test_helper"

describe Review do
  let(:review) { Review.new }

  it "is valid with a product_id" do
      review = Review.new
      review.product_id = products(:watch).id
      result = review.valid?
      result.must_equal true
  end

  it "is invalid without a product_id" do
      review = Review.new
      result = review.valid?
      result.must_equal false
      review.errors.messages.must_include :product_id
  end

  it "is valid with a rating" do
      review = Review.new
      review.product_id = 1
      review.rating = 2
      review.rating.must_be_instance_of Integer
  end

  it "rating is invalid if beyond 1-5" do
      review = Review.new
      review.product_id = 2
      review.rating = 9
      result = review.valid?
      result.must_equal false
      review.errors.messages.must_include :rating
  end

  it "is a valid review without a rating" do
      review = Review.new
      review.product_id = products(:watch).id
      result = review.valid?
      result.must_equal true
  end
end
