require "test_helper"

describe Orderproduct do
  let(:orderproduct) { Orderproduct.new }

  it "must be valid" do
    value(orderproduct).must_be :valid?
  end
end
