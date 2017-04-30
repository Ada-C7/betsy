require "test_helper"

describe Review do

  describe "relations" do
    it "review has a product" do
       review = reviews(:review1)
       review.must_respond_to :product
       review.product.must_be_kind_of Product
    end
  end # END of describe "relations"

  describe "validations" do
    let (:product) { products(:product1) }

    it "requires a rating" do
      review = Review.new(review: "something", product: product)
      review.valid?.must_equal false
      review.errors.messages.must_include :rating
    end

    it "rating must be a number" do
      review = Review.new(rating: "something", product: product)
      review.save.must_equal false
      review.errors.messages.must_include :rating
      review = Review.new(rating: 3, product: product)
      review.save.must_equal true
      review.valid?.must_equal true
    end

    it "rating must be between and including 1 and 5" do
      review = Review.new(rating: 0, product: product)
      review.valid?.must_equal false
      review.errors.messages.must_include :rating
      review = Review.new(rating: 1, product: product)
      review.valid?.must_equal true
      review = Review.new(rating: 6,product: product)
      review.valid?.must_equal false
      review.errors.messages.must_include :rating
    end
  end # END of describe "validations"

end
