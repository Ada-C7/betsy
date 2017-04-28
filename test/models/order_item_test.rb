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
  describe "check_order_status(id)" do
    it "checks all other items in order and changes order to complete if all items have been shipped" do
      order = orders(:check_status_order_one)
      order.status.must_equal "pending"

      order_item1 = order_items(:apple_check_status_order_one)
      order_item2 = order_items(:orange_check_status_order_one)

      order_item1.ship_status = true
      order_item1.save
      order_item1.ship_status.must_equal true

      order = order_item1.check_order_status(order_item1.order_id)
      order.status.must_equal "paid"

      order_item2.ship_status = true
      order_item2.save
      order_item2.ship_status.must_equal true
      order = order_item2.check_order_status(order_item2.order_id)

      order.status.must_equal "complete"
    end
    it "checks all other items in order and changes order to paid if one item has been changed from shipped to not shipped" do

      order = orders(:check_status_order_one)
      order_item1 = order_items(:apple_check_status_order_one)
      order_item2 = order_items(:orange_check_status_order_one)

      order_item1.ship_status = true
      order_item1.save

      order_item2.ship_status = true
      order_item2.save

      order = order_item2.check_order_status(order_item2.order_id)

      order.status.must_equal "complete"

      order_item2.ship_status = false
      order_item2.save

      order = order_item2.check_order_status(order_item2.order_id)

      order.status.must_equal "paid"
    end
  end
  describe "shipping_status" do
    it "returns proper shipping status when called" do
      order_item1 = order_items(:banana_check_status_order_one)
      order_item2 = order_items(:apple_check_status_order_one)

      order_item1.shipping_status.must_equal "Shipped"
      order_item2.shipping_status.must_equal "Not shipped yet"


    end

  end
end
