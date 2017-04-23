require "test_helper"

describe Order do
  let(:order) { Order.new }

  describe "validations" do
      it "You can create an order" do
        order = orders(:one)
        order.valid?.must_equal true
      end

      it "You can create an order without user" do
        order = orders(:no_user)
        order.valid?.must_equal true
        order.errors.messages[:user].must_equal []
      end

      it "Creates an order with default status pending" do
        order.email = "rainbowhoney@yahoo.com"
        order.billing_name = "Ada Lovelace"
        order.address = "11111 University Ave 95125"
        order.card_number = "2123338457430998498"
        order.card_expiration = "11/19"
        order.cvv = "364"
        order.zipcode = "95125"
        order.user_id = 1
        order.valid?.must_equal true
        order.status.must_equal "pending"
      end

      it "Cannot create an order without email" do
        order = orders(:missing_email)
        order.valid?.must_equal false
        order.errors.messages.must_include :email
      end

      it "Cannot create an order without billing names" do
        order = orders(:missing_billing_name)
        order.valid?.must_equal false
        order.errors.messages.must_include :billing_name
      end

      it "Cannot create an order without address" do
        order = orders(:missing_address)
        order.valid?.must_equal false
        order.errors.messages.must_include :address
      end

      it "Cannot create an order without card number" do
        order = orders(:missing_card_num)
        order.valid?.must_equal false
        order.errors.messages.must_include :card_number
      end

      it "Cannot create an order without card expiration" do
        order = orders(:missing_card_exp)
        order.valid?.must_equal false
        order.errors.messages.must_include :card_expiration
      end

      it "Cannot create an order without cvv" do
        order = orders(:missing_cvv)
        order.valid?.must_equal false
        order.errors.messages.must_include :cvv
      end

      it "Cannot create an order without missing zip" do
        order = orders(:missing_zip)
        order.valid?.must_equal false
        order.errors.messages.must_include :zipcode
      end

      it "Cannot create an order if email doesn't have @ symbol" do
        order.email = "testtest.com"
        order.billing_name = "Test Tester"
        order.address = "12345 Testing Ave 09876"
        order.card_number = "1234567890123456"
        order.card_expiration = "10/18"
        order.cvv = "123"
        order.zipcode ="12345"

        order.valid?.must_equal false
        order.errors.messages.must_include :email
      end

      it "Cannot create an order if card number is too short" do
        order.email = "test@test.com"
        order.billing_name = "Test Tester"
        order.address = "12345 Testing Ave 09876"
        order.card_number = "12345678"
        order.card_expiration = "10/18"
        order.cvv = "123"
        order.zipcode ="12345"

        order.valid?.must_equal false
        order.errors.messages.must_include :card_number
      end

      it "Cannot create an order if card number is too long" do
        order.email = "test@test.com"
        order.billing_name = "Test Tester"
        order.address = "12345 Testing Ave 09876"
        order.card_number = "123456781234567890123"
        order.card_expiration = "10/18"
        order.cvv = "123"
        order.zipcode ="12345"

        order.valid?.must_equal false
        order.errors.messages.must_include :card_number
      end

      it "Cannot create an order if cvv is too short" do
        order.email = "test@test.com"
        order.billing_name = "Test Tester"
        order.address = "12345 Testing Ave 09876"
        order.card_number = "1234567890123456"
        order.card_expiration = "10/18"
        order.cvv = "12"
        order.zipcode ="12345"

        order.valid?.must_equal false
        order.errors.messages.must_include :cvv
      end

      it "Cannot create an order if cvv is too long" do
        order.email = "test@test.com"
        order.billing_name = "Test Tester"
        order.address = "12345 Testing Ave 09876"
        order.card_number = "1234567890123456"
        order.card_expiration = "10/18"
        order.cvv = "1234"
        order.zipcode ="12345"

        order.valid?.must_equal false
        order.errors.messages.must_include :cvv
      end

      it "Cannot create an order if zipcode is too short" do
        order.email = "test@test.com"
        order.billing_name = "Test Tester"
        order.address = "12345 Testing Ave 09876"
        order.card_number = "1234567890123456"
        order.card_expiration = "10/18"
        order.cvv = "1234"
        order.zipcode ="1234"

        order.valid?.must_equal false
        order.errors.messages.must_include :zipcode
      end

      it "Cannot create an order if zipcode is too long" do
        order.email = "test@test.com"
        order.billing_name = "Test Tester"
        order.address = "12345 Testing Ave 09876"
        order.card_number = "1234567890123456"
        order.card_expiration = "10/18"
        order.cvv = "1234"
        order.zipcode ="123456"

        order.valid?.must_equal false
        order.errors.messages.must_include :zipcode
      end
    end

    describe "relations" do
      it "has a user" do
        order = orders(:one)
        order.user.must_equal users(:testuser)
      end

      it 'Can set the user through "user"' do
        order = orders(:one)
        order.user = users(:testuser)

        order.user_id.must_equal users(:testuser).id
      end

      it 'Can set the user through "user_id"' do
        order = orders(:two)
        order.user_id = users(:testuser).id

        order.user.must_equal users(:testuser)
      end
  end
end
