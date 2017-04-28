require "test_helper"

describe Order do

  describe 'validations' do
    before do
      @order = Order.create
      @order_data = {
                        status: "pending",
                        customer_name: "cynthia cobb",
                        customer_address: "123 st",
                        customer_email: "cyn@gmail.com",
                        customer_city: "seattle",
                        customer_zipcode: "12345",
                        customer_state: "WA",
                        credit_card_number: "1234567890123456",
                        credit_card_name: "bob bob",
                        credit_card_cvv: "123",
                        credit_card_zipcode: "12345"
                      }
    end

    it 'updates order if given good data' do
      @order.update_attributes(@order_data)
      @order.valid?.must_equal true
    end

    ############# CREDIT CARD VALIDATIONS ######################
    it 'returns error messages if no credit card info given' do
      @order_data[:credit_card_number] = ""
      @order.update_attributes(@order_data)
      @order.valid?.must_equal false
      @order.errors.messages.must_include :credit_card_number
    end

    # # # IT credit card under 16
    it 'returns error messages if credit card number is too short' do
      @order_data[:credit_card_number] = "123"
      @order.update_attributes(@order_data)
      @order.valid?.must_equal false
      @order.errors.messages.must_include :credit_card_number
    end

    # # # IT credit card too long/more than 16
    it 'returns error messages if credit card number is too long' do
      @order_data[:credit_card_number] = "12345678901234567"
      @order.update_attributes(@order_data)
      @order.valid?.must_equal false
      @order.errors.messages.must_include :credit_card_number
    end

    # # # IT no credit card name
    it "returns error messages if there's no credit card name" do
      @order_data[:credit_card_name] = ""
      @order.update_attributes(@order_data)
      @order.valid?.must_equal false
      @order.errors.messages.must_include :credit_card_name
    end

    # # # IT credit card name less than two
    it "returns error messages if creditcard name is short" do
      @order_data[:credit_card_name] = "c"
      @order.update_attributes(@order_data)
      @order.valid?.must_equal false
      @order.errors.messages.must_include :credit_card_name
    end

    it 'returns error messages if billing zip code is missing' do
      @order_data[:credit_card_zipcode] = ""
      @order.update_attributes(@order_data)
      @order.valid?.must_equal false
      @order.errors.messages.must_include :credit_card_zipcode
    end

    it 'returns error messages if billing zipcode is too short' do
      @order_data[:credit_card_zipcode] = "123"
      @order.update_attributes(@order_data)
      @order.valid?.must_equal false
      @order.errors.messages.must_include :credit_card_zipcode
    end

    it 'returns error messages if billing zipcode is too long' do
      @order_data[:credit_card_zipcode] = "123456"
      @order.update_attributes(@order_data)
      @order.valid?.must_equal false
      @order.errors.messages.must_include :credit_card_zipcode
    end

    it 'returns error messages if no cvv is given' do
      @order_data[:credit_card_cvv] = ""
      @order.update_attributes(@order_data)
      @order.valid?.must_equal false
      @order.errors.messages.must_include :credit_card_cvv
    end

    it 'returns error messages if cvv is short' do
      @order_data[:credit_card_cvv] = "12"
      @order.update_attributes(@order_data)
      @order.valid?.must_equal false
      @order.errors.messages.must_include :credit_card_cvv
    end

    it 'returns error messages if cvv is too long' do
      @order_data[:credit_card_cvv] = "1234"
      @order.update_attributes(@order_data)
      @order.valid?.must_equal false
      @order.errors.messages.must_include :credit_card_cvv
    end

    ########## CUSTOMER/SHIPPING VALIDATIONS ###########

    it 'returns error message if missing customer name' do
      @order_data[:customer_name] = ""
      @order.update_attributes(@order_data)
      @order.valid?.must_equal false
      @order.errors.messages.must_include :customer_name
    end

    it 'returns error message if customer name too short' do
      @order_data[:customer_name] = "c"
      @order.update_attributes(@order_data)
      @order.valid?.must_equal false
      @order.errors.messages.must_include :customer_name
    end

    it 'returns error message if missing address' do
      @order_data[:customer_address] = ""
      @order.update_attributes(@order_data)
      @order.valid?.must_equal false
      @order.errors.messages.must_include :customer_address
    end

    it 'returns error message if missing city' do
      @order_data[:customer_city] = ""
      @order.update_attributes(@order_data)
      @order.valid?.must_equal false
      @order.errors.messages.must_include :customer_city
    end

    it 'returns error message if missing state' do
      @order_data[:customer_state] = ""
      @order.update_attributes(@order_data)
      @order.valid?.must_equal false
      @order.errors.messages.must_include :customer_state
    end

    it 'returns error messages if zip code is missing' do
      @order_data[:customer_zipcode] = ""
      @order.update_attributes(@order_data)
      @order.valid?.must_equal false
      @order.errors.messages.must_include :customer_zipcode
    end

    it 'returns error messages if zip code is greater than 5 numbers' do
      @order_data[:customer_zipcode] = "123456"
      @order.update_attributes(@order_data)
      @order.valid?.must_equal false
      @order.errors.messages.must_include :customer_zipcode
    end

    it 'returns error messages if zip code is less than 5' do
      @order_data[:customer_zipcode] = "1234"
      @order.update_attributes(@order_data)
      @order.valid?.must_equal false
      @order.errors.messages.must_include :customer_zipcode
    end

    it 'returns error message if no email given' do
      @order_data[:customer_email] = ""
      @order.update_attributes(@order_data)
      @order.valid?.must_equal false
      @order.errors.messages.must_include :customer_email
    end

    it 'returns error message if given bad email' do
      @order_data[:customer_email] = "bob"
      @order.update_attributes(@order_data)
      @order.valid?.must_equal false
      @order.errors.messages.must_include :customer_email
    end
  end

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

  describe 'manage_inventory' do

    let(:bad_order) { Order.new }
    let(:good_order) { orders(:order2) }

    it "decreases the order's products inventory" do
      total_inventory_before = good_order.products.map {|product| product.inventory}.sum
      good_order.manage_inventory
      order_after = Order.find(good_order.id)
      total_inventory_after = order_after.products.map {|product| product.inventory}.sum
      total_inventory_after.must_be :<, total_inventory_before
    end

    it "return empty product_orders array if given bad order" do
      results = bad_order.manage_inventory
      results.empty?.must_equal true
    end
  end
end
