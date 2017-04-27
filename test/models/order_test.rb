require "test_helper"

describe Order do

  describe 'validations' do
    let(:complete_order) { orders(:order1) }

    # it "will create new instance when given good info" do
    #   order.customer_name = "cynthia"
    #   order.customer_address = "123 First St."
    #   order.customer_email = "cyn@gmail.com"
    #   order.customer_city = "bothell"
    #   order.customer_zipcode = "98011"
    #   order.customer_state = "WA"
    #   order.customer_cc_info = "1234567890123456"
    #   order.status = "paid"
    #   order.valid?.must_equal true
    # end

    it "will create a new instance when given good info" do
      complete_order.valid?.must_equal true
    end

      # will this get tested in the update OrdersController test?
    # it "will not update a new instance if needed data is missing" do
    #   order.valid?.must_equal false
    # end
  end

  # Order needs product, can't just do Order.new
  # Test Order(2), can make my own fixtures or change quantities

  describe 'calculate_totals' do
    let(:good_order) { orders(:order2) }
    let(:order_no_products) { orders(:order3) }

    it "assigns subtotal, tax, and total to an order" do
      good_order.calculate_totals
      good_order.subtotal.must_equal 20.1
      good_order.tax.must_equal 1.97
      good_order.total.must_equal 22.07
    end

    it "won't do anything if order has no products" do
      order_no_products.calculate_totals
      order_no_products.subtotal.must_equal 0
      order_no_products.tax.must_equal 0
      order_no_products.total.must_equal 0
    end
  end

  describe 'handle_inventory' do
    let(:good_order) { orders(:order2) }

    it 'decreases the product inventory' do
      total_inventory_before = good_order.products.map {|product| product.inventory}.sum
      good_order.handle_inventory
      order_after = Order.find(good_order.id)
      total_inventory_after = order_after.products.map {|product| product.inventory}.sum
      total_inventory_after.must_be :<, total_inventory_before
    end

    it 'does nothing if order has not product_orders' do
      
    end
  end
end
