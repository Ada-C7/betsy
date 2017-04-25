require "test_helper"

describe ProductOrder do

  describe 'validations' do
    before do
      @good_order = orders(:order2)
      @good_product = products(:product1)

      @bad_order_id = (Order.last.id) + 1
      @bad_product_id = (Order.last.id) + 1
    end

    it 'passes validations if product and order exist' do
      product_order = product_orders(:product_order1)
      product_order.valid?.must_equal true
    end

    it 'wont create an instance if product DNE' do
      bad_PO = ProductOrder.new
      bad_PO.product_id = @bad_product_id

      bad_PO.order_id = @good_order.id
      bad_PO.valid?.must_equal false
    end

    it 'wont create an instance if order DNE' do
      bad_PO = ProductOrder.new
      bad_PO.product_id = @good_product.id
      bad_PO.order_id = @bad_order_id
      bad_PO.valid?.must_equal false
    end

    it 'wont createa an instance if order & product DNE' do
      bad_PO = ProductOrder.new
      bad_PO.product_id = @bad_product_id
      bad_PO.order_id = @bad_order_id
      bad_PO.valid?.must_equal false
    end
  end

  describe 'add_product' do

    before do
      @good_order = orders(:order2)
      @good_product = products(:product1)

      # @product_order1 = product_orders(:product_order1)
      # @product_order2 = product_orders(:product_order2)
    end

    it 'instiates a new ProductOrder instance' do
      output = ProductOrder.add_product( @good_product.id, @good_order.id)
      output.must_be_instance_of ProductOrder
      output.valid?.must_equal true
    end
  end

end
