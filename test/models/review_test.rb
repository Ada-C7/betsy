require "test_helper"

describe Review do
  let(:review) { Review.new }

  it "all reviews must be be valid" do
    reviews.each do |review|
      value(review).must_be :valid?
    end
  end

  describe "validation tests" do
    # required test (1/3)
    it "Rating must be present" do
      proc { review.save! }.must_raise ("A review must have a rating.")
      review.errors.must_include(:rating)
    end

    # required test (2/3)
    it "Rating must be an Integer" do
      review[:rating] = "string"
      review.save

      review.wont_be :valid?
    end

    # required test (3/3)
    it "rating must be a number between 1 and 5" do
      review[:rating] = 7
      review.save

      review.wont_be :valid?
    end
  end

  describe "association test" do
    it "#product" do
      assert_equal "MyString", reviews(:one).product.name
    end
  end
end
