require "test_helper"

describe Productorder do
  let(:productorder) { Productorder.new }

  it "must be valid" do
    value(productorder).must_be :valid?
  end
end
