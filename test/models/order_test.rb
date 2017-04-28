require "test_helper"

describe Order do

  describe 'validations' do
    before do
      @order = Order.create

      @order_good_data = {
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
      # test all validations? this one is NO credit card
      @order_no_cc = {
                        customer_name: "cynthia cobb",
                        customer_address: "123 st",
                        customer_email: "cyn@gmail.com",
                        customer_city: "seattle",
                        customer_zipcode: "12345",
                        customer_state: "WA"
                      }
      # credit card under 16
      @order_cc_short = {
                          status: "pending",
                          customer_name: "cynthia cobb",
                          customer_address: "123 st",
                          customer_email: "cyn@gmail.com",
                          customer_city: "seattle",
                          customer_zipcode: "12345",
                          customer_state: "WA",
                          credit_card_number: "123456789012345"
                        }

      # credit card too long/more than 16
      @order_cc_long = {
                          status: "pending",
                          customer_name: "cynthia cobb",
                          customer_address: "123 st",
                          customer_email: "cyn@gmail.com",
                          customer_city: "seattle",
                          customer_zipcode: "12345",
                          customer_state: "WA",
                          credit_card_number: "12345678901234567"
                        }
      # zip code too short
      @order_zip_short = {
                            status: "pending",
                            customer_name: "cynthia cobb",
                            customer_address: "123 st",
                            customer_email: "cyn@gmail.com",
                            customer_city: "seattle",
                            customer_zipcode: "1234",
                            customer_state: "WA",
                            credit_card_number: "1234567890123456"
                          }
      # zip code too long
      @order_zip_long = {
                          status: "pending",
                          customer_name: "cynthia cobb",
                          customer_address: "123 st",
                          customer_email: "cyn@gmail.com",
                          customer_city: "seattle",
                          customer_zipcode: "123456",
                          customer_state: "WA",
                          credit_card_number: "1234567890123456"
                        }
      # zip code not present
      @order_no_zip = {
                        status: "pending",
                        customer_name: "cynthia cobb",
                        customer_address: "123 st",
                        customer_email: "cyn@gmail.com",
                        customer_city: "seattle",
                        customer_state: "WA",
                        credit_card_number: "1234567890123456"
                      }
      # no credit card name
      @order_no_name = {
                          status: "pending",
                          customer_address: "123 st",
                          customer_email: "cyn@gmail.com",
                          customer_city: "seattle",
                          customer_zipcode: "12345",
                          customer_state: "WA",
                          credit_card_number: "1234567890123456"
                        }

      # credit card name less than two
      @order_name_short = {
                            status: "pending",
                            customer_name: "c",
                            customer_address: "123 st",
                            customer_email: "cyn@gmail.com",
                            customer_city: "seattle",
                            customer_zipcode: "12345",
                            customer_state: "WA",
                            credit_card_number: "1234567890123456"
                          }

    end

    it 'updates order if given good data' do
      @order.update_attributes(@order_good_data)
      @order.valid?.must_equal true
    end

    it 'returns error messages if no credit card info given' do
      @order.update_attributes(@order_no_cc)
      @order.valid?.must_equal false
      @order.errors.messages.must_include :credit_card_number
    end

    #
    # # IT credit card under 16
    it 'returns error messages if credit card number is less than 16 numbers' do
      @order.update_attributes(@order_cc_short)
      @order.valid?.must_equal false
      @order.errors.messages.must_include :credit_card_number
    end
    #
    # # IT credit card too long/more than 16
    it 'returns error messages if credit card number is greater than 16 numbers' do
      @order.update_attributes(@order_cc_long)
      @order.valid?.must_equal false
      @order.errors.messages.must_include :credit_card_number
    end
    #
    # # IT zip code too short
    it 'returns error messages if zip code is less than 5 numbers' do
      @order.update_attributes(@order_zip_short)
      @order.valid?.must_equal false
      @order.errors.messages.must_include :customer_zipcode
    end
    #
    # # IT zip code too long
    it 'returns error messages if zip code is greater than 5 numbers' do
      @order.update_attributes(@order_zip_long)
      @order.valid?.must_equal false
      @order.errors.messages.must_include :customer_zipcode
    end
    #
    # # IT zip code not present
    it 'returns error messages if zip code is greater than 5 numbers' do
      @order.update_attributes(@order_zip_short)
      @order.valid?.must_equal false
      @order.errors.messages.must_include :customer_zipcode
    end
    #
    # # IT no credit card name
    it "returns error messages if there's no credit card name" do
      @order.update_attributes(@order_no_name)
      @order.valid?.must_equal false
      @order.errors.messages.must_include :customer_name
    end
    #
    # # IT credit card name less than two
    it "returns error messages if credit card name less than two characters" do
      @order.update_attributes(@order_name_short)
      @order.valid?.must_equal false
      @order.errors.messages.must_include :customer_name
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
