require "test_helper"

describe ReviewsController do
  it "should get new" do
    get reviews_new_url
    value(response).must_be :success?
  end

  it "should get index" do
    get reviews_index_url
    value(response).must_be :success?
  end

end
