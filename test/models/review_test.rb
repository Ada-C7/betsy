require "test_helper"

describe Review do

  describe "relationships" do

    it "belongs to a product" do
      review = reviews(:one)
      review.product.nil?.must_equal false
    end

    it "can find a product id through the relationship" do
      review = reviews(:one)
      review.product.id.must_equal 1
    end

    it "can be found through the product's information" do
      product = products(:one)
      product.reviews.first.class.must_equal Review
    end

    it "contains a product id" do
      review = reviews(:one)
      review.must_respond_to :product_id
    end

  end

  describe "validations" do

    it "responds to rating" do
      review = reviews(:one)
      review.must_respond_to :rating
    end 

    it "is invalid without a rating" do
      review = reviews(:no_rating)
      review.valid?.must_equal false
    end

    it "is valid with a rating" do
      review = reviews(:one)
      review.valid?.must_equal true
    end

    it "is valid without a name or comment" do
      review = reviews(:two)
      review.valid?.must_equal true
    end

    it "requires a numerical rating" do
      review = reviews(:numerical)
      review.valid?.must_equal false
    end

    it "requires rating to be an integer" do
      review = reviews(:float)
      review.rating = 3.6
      review.valid?.must_equal false
    end

    it "requires a rating between 1-5" do
      review = reviews(:one)
      review.valid?.must_equal true

      preview = reviews(:five)
      review.valid?.must_equal true

      mreview = reviews(:float)
      mreview.rating = 6
      mreview.valid?.must_equal false

      breview = reviews(:numerical)
      breview.rating = 0
      breview.valid?.must_equal false

      dreview = reviews(:two)
      dreview.rating = -1
      dreview.valid?.must_equal false
    end
  end
end
