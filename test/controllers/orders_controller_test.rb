require "test_helper"

describe OrdersController do

  describe "index" do
    it "gets index" do
      get orders_path
      must_respond_with :success
    end
  end

  describe "show" do
    it "should get show" do
      order = Order.first
      get orders_path(order)
      must_respond_with :success
    end
  end

  describe "new" do
    it "should get new" do
      get new_order_path
      must_respond_with :success
    end
  end

end
