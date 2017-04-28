require "test_helper"

describe Order do
  let(:order) { Order.new }

  it "all orders must be valid" do
    orders.each do |order|
      value(order).must_be :valid?
    end
  end

  # required test (1/1)
  # TODO: WHAT IS THIS?
  it "has one or more productorders for a 'paid' order" do
  end

  describe "validation tests" do

    it "order with correct validations is valid" do
      orders(:two).must_be :valid?
    end

    it "order with missing data is invalid" do
      order.must_be :invalid?
    end

    it  "new order can not be valid without a status" do
      order = orders(:two)
      order[:status] = nil
      order.save

      order.wont_be :valid?
    end

    it  "new order can not have an invalid status" do
      order = orders(:two)
      order[:status] = "invalid"
      order.save

      order.wont_be :valid?
    end

    it  "new order can only have a valid status (pending)" do
      order = orders(:two)
      order[:status] = "pending"
      order.save

      order.must_be :valid?
    end

    it  "new order can only have a valid status (paid)" do
      order = orders(:two)

      order.must_be :valid?
    end

    it  "new order can only have a valid status (complete)" do
      order = orders(:two)
      order[:status] = "complete"
      order.save

      order.must_be :valid?
    end

    it  "new order can only have a valid status (cancelled)" do
      order = orders(:two)
      order[:status] = "cancelled"
      order.save

      order.must_be :valid?
    end

    it "order is valid with proper email" do
      order = orders(:two)
      order[:email_address] =  nil
      order.save

      orders(:two).wont_be :valid?
    end

    it "order is invalid without an email" do
      order = orders(:two)
      order[:email_address] =  nil
      order.save

      orders(:two).wont_be :valid?
    end

    it "order is invalid without a valid email (missing @)" do
      order = orders(:two)
      order[:email_address] =  "invalidemailgmail.com"
      order.save

      orders(:two).wont_be :valid?
    end

    it "order is invalid without a valid email (missing .)" do
      order = orders(:two)
      order[:email_address] =  "invalidemail@gmailcom"
      order.save

      orders(:two).wont_be :valid?
    end

    it  "order is invalid without a mailing address" do
      order = orders(:two)
      order[:mailing_address] = nil
      order.save

      order.wont_be :valid?
    end

    it "if status is paid, order is valid if name is present" do
      order = orders(:two)

      order.must_be :valid?
    end

    it "if status is paid, order is invalid if name is not present" do
      order = orders(:two)
      order[:status] = "paid"
      order[:card_name] = nil
      order.save

      order.wont_be :valid?
    end

    it "if status is complete, order is valid if name is present" do
      order = orders(:two)
      order[:status] = "complete"
      order.save

      order.must_be :valid?
    end

    it "if status is complete, order is invalid if name is not present" do
      order = orders(:two)
      order[:status] = "complete"
      order[:card_name] = nil
      order.save

      order.wont_be :valid?
    end

    it "order does not need name if status is pending" do
      order = orders(:two)
      order[:status] = "pending"
      order[:card_name] = nil
      order.save

      order.must_be :valid?
    end

    it "order does not need name if status is cancelled" do
      order = orders(:two)
      order[:status] = "cancelled"
      order[:card_name] = nil
      order.save

      order.must_be :valid?
    end


    describe "Card CVV validations" do

      it "if status is paid, order is invalid if card expiration is not present" do
        order = orders(:two)
        order[:card_expiration] = nil
        order.save

        order.wont_be :valid?
      end

      it "if status is complete, order is invalid if card expiration is not present" do
        order = orders(:two)
        order[:status] = "complete"
        order[:card_cvv] = nil
        order.save

        order.wont_be :valid?
      end

      it "if status is paid, order is valid if card expiration is present" do
        order = orders(:two)

        order.must_be :valid?
      end

      it "if status is complete, order is valid if card expiration is present" do
        order = orders(:two)
        order[:status] = "complete"
        order.save

        order.must_be :valid?
      end

      it "if status is pending, order is valid if card expiration is not present" do
        order = orders(:two)
        order[:status] = "pending"
        order[:card_expiration] = nil
        order.save

        order.must_be :valid?
      end

      it "if status is cancelled, order is valid if card expiration is not present" do
        order = orders(:two)
        order[:status] = "cancelled"
        order[:card_expiration] = nil
        order.save

        order.must_be :valid?
      end
    end

    describe "Card CVV validations" do
      it "card cvv is invalid if longer than 3 numbers" do
        order = orders(:two)
        order[:card_cvv] = 2345
        order.save

        order.wont_be :valid?
      end


      it "card cvv is not valid if 3 characters" do
        order = orders(:two)
        order[:card_cvv] = "abc"
        order.save

        order.wont_be :valid?
      end

      #
      it "if status is paid, order is invalid if card cvv is not present" do
        order = orders(:two)
        order[:card_cvv] = nil
        order.save

        order.wont_be :valid?
      end

      it "if status is complete, order is invalid if card cvv is not present" do
        order = orders(:two)
        order[:status] = "complete"
        order[:card_cvv] = nil
        order.save

        order.wont_be :valid?
      end

      it "if status is paid, order is valid if card cvv is present" do
        order = orders(:two)

        order.must_be :valid?
      end

      it "if status is cancelled, order is valid if card cvv is present" do
        order = orders(:two)
        order[:status] = "cancelled"
        order.save

        order.must_be :valid?
      end

      it "if status is pending, order is valid if card cvv is not present" do
        order = orders(:two)
        order[:status] = "pending"
        order[:card_cvv] = nil


        order.must_be :valid?
      end

      it "if status is cancelled, order is valid if card cvv is not present" do
        order = orders(:two)
        order[:status] = "cancelled"
        order[:card_cvv] = nil
        order.save

        order.must_be :valid?
      end
    end

    describe "Zipcode validations" do

      it "Zipcode is invalid unless 5 numbers" do
        order = orders(:two)
        order[:zipcode] = 123456
        order.save

        order.wont_be :valid?
      end

      it "Zipcode is invalid if 5 characters" do
        order = orders(:two)
        order[:zipcode] = 'abcde'
        order.save

        order.wont_be :valid?
      end

      it "if status is paid, order is invalid if zipcode is not present" do
        order = orders(:two)
        order[:zipcode] = nil
        order.save

        order.wont_be :valid?
      end

      it "if status is complete, order is invalid if zipcode is not present" do
        order = orders(:two)
        order[:status] = "complete"
        order[:zipcode] = nil
        order.save

        order.wont_be :valid?
      end

      it "if status is pending, order is valid if zipcode is not present" do
        order = orders(:two)
        order[:status] = "pending"
        order[:zipcode] = nil
        order.save

        order.must_be :valid?
      end

      it "if status is cancelled, order is valid if zipcode is not present" do
        order = orders(:two)
        order[:status] = "cancelled"
        order[:zipcode] = nil
        order.save

        order.must_be :valid?
      end
      #
    end

    it "new order can not be created without a credit card" do
      order = orders(:two)
      order[:credit_card] = nil
      order.save

      order.wont_be :valid?
    end

  end

  describe "associations test" do
    # it "#product_orders - an order can have multiple product orders" do
    #   # skip
    #   assert_equal 2, orders(:one).product_orders.size
    # end
    #
    # it "#user_orders" do
    # end
  end
end


# describe "associations test" do
#   it "#product_categories - recognizes the correct number" do
#     assert_equal 2, categories(:one).product_categories.size
#   end
