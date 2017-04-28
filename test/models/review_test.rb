require "test_helper"

describe Review do
  describe 'validations' do
    it "Can be created with rating and review_text" do
      review = reviews(:one)
      result = review.valid?
      result.must_equal true
    end

    it "can't be created without rating" do
      review = Review.new(review_text: "don't buy again")
      result = review.valid?
      result.must_equal false
    end

    it "can't be created without review_text" do
      review = Review.new(rating: 4)
      result = review.valid?
      result.must_equal false
    end

    it "rating has to be between 1-5" do
      review = Review.new(rating: 7, review_text: "don't buy again")
      result = review.valid?
      result.must_equal false
    end

    it "rating has to be between 1-5" do
      review = Review.new(rating: -2, review_text: "don't buy again")
      result = review.valid?
      result.must_equal false
    end
  end
  describe 'relationship' do
    it "I can access reviews for products" do
      product_review = reviews(:one).product
      product_review.must_equal products(:owl1)
    end

    it "has access product's price through review" do
      product_review = reviews(:one).product.price
      product_review.must_equal 20
    end

    it "has access product's stock through review" do
      product_review = reviews(:one).product.stock
      product_review.must_equal 2
    end
  end

end
