require "test_helper"

describe ProductOrder do
  let(:product_order) { ProductOrder.new }

  it "must be valid" do
    product_orders.each do |product_order|
      value(product_order).must_be :valid?
    end
  end
  describe "validation tests" do

    # required test (3/5)
    it "Quantity must be present" do
      product_order[:quantity] = 0
      product_order.save

      product_order.must_be :invalid?
    end

    # required test (4/5)
    it "Quantity must be an integer" do
      product_order[:quantity] = "String"
      product_order.save

      product_order.must_be :invalid?
    end

    # required test (5/5)
    it "Quantity must be greater than 0" do
      product_order[:quantity] = 0
      product_order.save

      product_order.must_be :invalid?
    end
  end

  describe "association tests" do
    # required test (1/5)
    it "Must belong to a Product" do
      assert_equal 1, product_orders(:one).product_id
    end

    # required test (2/5)
    it "Must belong to an Order" do
      assert_equal 1, product_orders(:one).order_id
    end
  end
end
