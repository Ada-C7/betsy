require "test_helper"

describe UserOrder do
  let(:user_order) { UserOrder.new }

  it "must be valid" do
    user_orders.each do |user_order|
      value(user_order).must_be :valid?
    end
  end

  describe "association test" do
    it "Product order has one user" do
      assert_equal 1, user_orders(:one).user_id
    end
    it "Product order has one order" do
      assert_equal 1, user_orders(:one).order_id
    end
  end
end
