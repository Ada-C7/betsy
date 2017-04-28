require "test_helper"

# require "test_helper"
#
# describe CartsController do
#   # it "must be a real test" do
#   #   flunk "Need real tests"
#   # end
# end

describe CartsController do
  it "should get show" do
    get carts_show_url
    value(response).must_be :success?
  end


end
