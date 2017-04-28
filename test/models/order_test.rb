require "test_helper"

describe Order do
  let(:order) { Order.new }

  # Leaving this in in case we add this back in.
  # it "must have at least one order_item" do
  #   order.valid?.must_equal false
  #   order.errors.messages.must_include :order_items
  # end

  it "can be created and is valid" do
    #order items fixture has to be wrapped in an array
    #to_do maybe fix the fixtures?
    order.valid?.must_equal true
  end

  it "can be created with multiple order_items" do
    order.order_items = [order_items(:socks), order_items(:shirts)]
    order.valid?.must_equal true
  end

  it "can access order_items" do
    order.order_items = [order_items(:socks), order_items(:shirts)]
    order.must_respond_to :order_items
  end

  describe "#Total" do
    it "returns a float" do
      total = orders(:order_one).total
      total.must_be_instance_of Float
    end

    it "returns the total of all of the order_items subtotals" do
      items = orders(:order_one).order_items
      total = 0
      items.each do |item|
        total += item.subtotal
      end
      orders(:order_one).total.must_equal total
    end

    it "If order has no order_items, returns 0" do
      orders(:order_two).total.must_equal 0
    end
  end

  describe "#Products" do
    it "returns an array of products" do
      order = orders(:order_one)
      order.products.must_be_instance_of Array
      order.products.each do |product|
        product.must_be_instance_of Product
      end
    end

    it "returns an empty array if order has no products in it" do
      order = orders(:order_two)
      order.products.must_equal []
    end
  end
end
