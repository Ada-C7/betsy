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

    #
      # will this get tested in the update OrdersController test?
    # it "will not update a new instance if needed data is missing" do
    #   order.valid?.must_equal false
    # end
  end

  # Order needs product, can't just do Order.new
  # Test Order(2), can make my own fixtures or change quantities

  describe 'calculate_totals' do

    let(:good_order) { orders(:order2) }

    # order 2 has 3 product

    it "assigns subtotal, tax, and total to an order" do
      good_order.calculate_totals
      good_order.subtotal.must_equal 20.1
      good_order.tax.must_equal 1.97
      good_order.total 22.07

    end

    it "text" do

    end

    it "returns the subtotal plus tax" do

    end

    it "returns the " do

    end


  end

end
