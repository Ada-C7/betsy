require "test_helper"

describe Review do
  let(:review) { reviews(:goodone, :badone).sample }

  describe "relationships" do
    it "returns a product" do
      review.product.must_be_instance_of Product
      review.product.reviews.must_include review
    end

    it "product still exists if review deleted" do
      review = Review.create(rating: 5, comment: "most perfect", product: products(:kidjams))
      review.destroy
      products(:kidjams).wont_be_nil
    end
  end

  describe "validations" do
    it "is valid with an integer rating 1-5" do
      review.valid?
      review.errors.messages[:rating].must_equal []
    end

    it "is invalid without a rating" do
      review = Review.create(comment: "hrmmm")
      review.valid?.must_equal false
      review.errors.messages.must_include :rating
    end

    it "is invalid without an integer rating" do
      review = Review.create(rating: "alright", comment: "hrmmm")
      review.valid?.must_equal false
      review.errors.messages.must_include :rating
    end

    it "is invalid without a rating greater than 0" do
      review = Review.create(rating: -1000, comment: "hrmmm")
      review.valid?.must_equal false
      review.errors.messages.must_include :rating
    end

    it "is invalid without a rating less than 6" do
      review = Review.create(rating: 9999, comment: "hrmmm")
      review.valid?.must_equal false
      review.errors.messages.must_include :rating
    end

    it "is valid without a comment" do
      review = Review.create(rating: 5)
      review.valid?
      review.errors.messages[:comment].must_equal []
    end
  end
end
