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
    #
      # will this get tested in the update OrdersController test?
    # it "will not update a new instance if needed data is missing" do
    #   order.valid?.must_equal false
    # end
  end
end
