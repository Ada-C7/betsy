require "test_helper"

describe OrderItem do
  let(:order_item) { OrderItem.new }

  it "new order_item requires a quanitity" do
    order_item.valid?.must_equal false
    order_item.errors.messages.must_include :quantity
  end

  it "quantity must be greater than 0" do
    order_item.product_id = products(:fancy_socks).id
    order_item.order_id = orders(:order_one).id
    order_item.quantity = 0
    order_item.valid?.must_equal false
    order_item.errors.messages.must_include :quantity
  end

  it "quantity must be an integer" do
    order_item.product_id = products(:fancy_socks).id
    order_item.order_id = orders(:order_one).id
    order_item.quantity = "two"
    order_item.valid?.must_equal false
    order_item.errors.messages.must_include :quantity
  end

  it "new order_item requires a Product" do
    order_item.quantity = 2
    order_item.valid?.must_equal false
    order_item.errors.messages.must_include :product
  end

  it "new order_item requires an Order" do
    order_item.quantity = 2
    order_item.product_id = products(:fancy_socks).id
    order_item.valid?.must_equal false
    order_item.errors.messages.must_include :order
  end

  it "can create a new order item" do
    order_item.quantity = 2
    order_item.product_id = products(:fancy_socks).id
    order_item.order_id = orders(:order_one).id
    order_item.save.must_equal true
  end

  describe "#Subtotal" do
    it "returns a float" do
      order_item.quantity = 2
      order_item.product_id = products(:fancy_socks).id
      order_item.order_id = orders(:order_one).id
      order_item.subtotal.must_be_instance_of Float
    end

    it "returns the price of item * quantity" do
      order_item.quantity = 2
      order_item.product_id = products(:fancy_socks).id
      order_item.order_id = orders(:order_one).id

      manual = order_item.quantity * products(:fancy_socks).price

      order_item.subtotal.must_equal manual
    end

    it "returns 0 if quantity is 0" do
      order_item.quantity = 0
      order_item.product_id = products(:fancy_socks).id
      order_item.order_id = orders(:order_one).id

      order_item.subtotal.must_equal 0
    end

    it "returns nil if product does not exist" do
      order_item.quantity = 3
      order_item.product_id = 1
      order_item.order_id = orders(:order_one).id

      order_item.subtotal.must_be_nil
    end
  end
end
