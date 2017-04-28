require "test_helper"

describe Review do
  let(:review) { Review.new }

  it "creates a rating" do
    review.rating = 3
    review.product_id = products(:apple).id
    review.valid?.must_equal true
  end

  it "should have rating present" do
    reviews(:has_rating).valid?.must_equal true
    reviews(:no_rating).valid?.must_equal false
  end

  it "rating should be between 1-5" do
    reviews(:has_rating).valid?.must_equal true
    reviews(:rating_not_between).valid?.must_equal false
    reviews(:negative_rating).valid?.must_equal false
  end

  it "should be an integer" do
    reviews(:not_integer).valid?.must_equal false
  end

end
