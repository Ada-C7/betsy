require "test_helper"

describe Order do
  let(:order) { Order.new }

  describe "validations" do
    it "You can create an order" do
      order.valid?.must_equal true
    end

    it "Creates an order with default status pending" do
      order.valid?.must_equal true
      order.status.must_equal "pending"
    end

    it "Cannot create a paid order without email" do
      order = orders(:missing_email)
      order.valid?.must_equal false
      order.errors.messages.must_include :email
    end

    it "Cannot create a paid order without billing names" do
      order = orders(:missing_billing_name)
      order.valid?.must_equal false
      order.errors.messages.must_include :billing_name
    end

    it "Cannot create a paid order without address" do
      order = orders(:missing_address)
      order.valid?.must_equal false
      order.errors.messages.must_include :address
    end

    it "Cannot create a paid order without card number" do
      order = orders(:missing_card_num)
      order.valid?.must_equal false
      order.errors.messages.must_include :card_number
    end

    it "Cannot create a paid order without card expiration" do
      order = orders(:missing_card_exp)
      order.valid?.must_equal false
      order.errors.messages.must_include :card_expiration
    end

    it "Cannot create a paid order without cvv" do
      order = orders(:missing_cvv)
      order.valid?.must_equal false
      order.errors.messages.must_include :cvv
    end

    it "Cannot create a paid order without missing zip" do
      order = orders(:missing_zip)
      order.valid?.must_equal false
      order.errors.messages.must_include :zipcode
    end

    it "Cannot create a paid order if email doesn't have @ symbol" do
      order = orders(:one)
      order.email = "testtest.com"

      order.valid?.must_equal false
      order.errors.messages.must_include :email
    end

    it "Cannot create a paid order if card number is too short" do
      order = orders(:two)
      order.card_number = "12345678"

      order.valid?.must_equal false
      order.errors.messages.must_include :card_number
    end

    it "Cannot create a paid order if card number is too long" do
      order = orders(:one)
      order.card_number = "123456781234567890123"

      order.valid?.must_equal false
      order.errors.messages.must_include :card_number
    end

    it "Cannot create a paid order if cvv is too short" do
      order = orders(:two)
      order.cvv = "12"

      order.valid?.must_equal false
      order.errors.messages.must_include :cvv
    end

    it "Cannot create an order if cvv is too long" do
      order = orders(:one)
      order.cvv = "12345"

      order.valid?.must_equal false
      order.errors.messages.must_include :cvv
    end

    it "Cannot create an order if zipcode is too short" do
      order = orders(:one)
      order.zipcode ="1234"

      order.valid?.must_equal false
      order.errors.messages.must_include :zipcode
    end

    it "Cannot create an order if zipcode is too long" do
      order = orders(:two)
      order.zipcode ="123456"

      order.valid?.must_equal false
      order.errors.messages.must_include :zipcode
    end

    it "Cannot create an order without missing zip" do
      order = orders(:missing_zip)
      order.valid?.must_equal false
      order.errors.messages.must_include :zipcode
    end
  end

  describe "total_cost" do
    it "calculates total cost of an order" do
      order = orders(:four)
      order.total_cost.must_equal 40.0
    end
  end

  describe "card_last_digits" do
    it "displayes only the last 4 digits of given credit card number" do
      order = orders(:three)
      order.card_last_digits.must_equal "xxxxxxxxxxxxxxx9984"
    end
  end
end
