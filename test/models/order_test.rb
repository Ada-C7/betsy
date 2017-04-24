require "test_helper"

describe Order do

  describe 'validations' do
    let(:order) { Order.new }

    # it "will create new instance when given all needed info" do
    #   order.customer_name = "cynthia"
    #   order.customer_address = "123 First St."
    #   order.customer_email = "cyn@gmail.com"
    #   # order.customer_city
    #   # order.customer_zipcode
    #   # order.customer_state
    #   order.customer_cc_info = "1234567890123456"
    #   order.status = "paid"
    #   order.valid?.must_equal true
    # end
    #
    # it "will not create a new instance if needed data is missing" do
    #   order.valid?.must_equal false
    # end
    #
    # it "will not save a order unless status is paid" do
    #   order.customer_name = "cynthia"
    #   order.customer_address = "123 First St."
    #   order.customer_email = "cyn@gmail.com"
    #   # order.customer_city
    #   # order.customer_zipcode
    #   # order.customer_state
    #   order.customer_cc_info = "1234567890123456"
    #   order.valid?.must_equal false
    # end
    #
    # it "will not create new instance unless given a 16 digit cc" do
    #   order.customer_name = "cynthia"
    #   order.customer_address = "123 First St."
    #   order.customer_email = "cyn@gmail.com"
    #   # order.customer_city
    #   # order.customer_zipcode
    #   # order.customer_state
    #   order.customer_cc_info = "12345678901"
    #   order.status = "paid"
    #   order.valid?.must_equal false
    # end
  end
end
