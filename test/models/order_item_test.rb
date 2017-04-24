require "test_helper"

describe OrderItem do
  let(:order_item) { OrderItem.new }

  describe "validations" do
    it "You can create an OrderItem" do
      item = order_items(:one)
      item.valid?.must_equal true
    end

    it "Cannot create an OrderItem without quantity" do
      item = order_items(:missing_quantity)
      item.valid?.must_equal false
      item.errors.messages.must_include :quantity
    end

    it "Cannot create an OrderItem with 0 quantity" do
      order_item.order = orders(:two)
      order_item.product = products(:famjams)
      order_item.quantity = 0

      order_item.valid?.must_equal false
      order_item.errors.messages.must_include :quantity
    end

    it "Cannot create an OrderItem with non-numeric quantity" do
      order_item.order = orders(:two)
      order_item.product = products(:famjams)
      order_item.quantity = "fifteen"

      order_item.valid?.must_equal false
      order_item.errors.messages.must_include :quantity
    end

    it "Cannot create an OrderItem without an order" do
      item = order_items(:missing_order)
      item.valid?.must_equal false
      item.errors.messages.must_include :order
    end

    it "Cannot create an OrderItem without a product" do
      item = order_items(:missing_product)
      item.valid?.must_equal false
      item.errors.messages.must_include :product
    end

    it "Can create an OrderItem with an order and a product" do
      order_item.order = orders(:one)
      order_item.product = products(:hotdamnjams)
      order_item.quantity = 4

      order_item.valid?.must_equal true
    end
  end

  describe "relations" do
    it "has an order" do
      item = order_items(:one)
      item.order.must_equal orders(:one)
    end

    it 'Can set the order through "order"' do
      item = order_items(:two)
      item.order = orders(:two)

      item.order_id.must_equal orders(:two).id
    end

    it 'Can set the order through "order_id"' do
      item = order_items(:two)
      item.order_id = orders(:two).id

      item.order.must_equal orders(:two)
    end

    it "has a product" do
      item = order_items(:one)
      item.product.must_equal products(:kidjams)
    end

    it 'Can set the order through "product"' do
      item = order_items(:two)
      item.product = products(:jamjams)

      item.product_id.must_equal products(:jamjams).id
    end

    it 'Can set the order through "product_id"' do
      item = order_items(:two)
      item.product_id = products(:hotdamnjams).id

      item.product.must_equal products(:hotdamnjams)
    end
  end

end
