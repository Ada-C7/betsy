require "test_helper"

describe Order do

  describe "relationships" do
    it "can have many products" do
      order = orders(:one)
      order.products.count.must_equal 2
    end

    it "can have many orderproducts" do
      order = orders(:one)
      order.orderproducts.count.must_equal 2
    end
    #
    it "has many merchants" do
      order = orders(:one)
      order.merchants.count.must_equal 2
    end
  end

  describe "validations" do
    it "can create a order with a status" do
      order = Order.create(status: "pending")
      order.errors.messages.wont_include :status
    end

    it "cannot create a order with a status that isn't pending, paid, complete, cancelled" do
      order = Order.create(status: "test")
      order.errors.messages.must_include :status
    end
    #
    #   it "is invalid without a order_email" do
    #     order = Order.new
    #     result = order.valid?
    #     result.must_equal false
    #
    #     order.errors.messages.must_include :order_email
    #   end
    #
    #   it "is invalid with a duplicate order_email" do
    #     order1 = Order.create(username: "TestUser", order_name: "Test", order_email: "test@petsy.com", oauth_uid: "1234", oauth_provider: "github")
    #     order2 = Order.new(username: "Lala", order_name: "TestTwo", order_email: "test@petsy.com", oauth_uid: "5678", oauth_provider: "github")
    #     result = order2.valid?
    #     result.must_equal false
    #
    #     order2.errors.messages.must_include :order_email
    #   end
    #
    #   it "can create a order with a username" do
    #     order = Order.create(username: "TestUser")
    #     order.errors.messages.wont_include :username
    #   end
    #
    #   it "is invalid without a username" do
    #     order = Order.new
    #     result = order.valid?
    #     result.must_equal false
    #
    #     order.errors.messages.must_include :username
    #   end
    #
    #   it "is invalid with a duplicate username" do
    #     order1 = Order.create(username: "TestUser", order_name: "Test", order_email: "test@petsy.com", oauth_uid: "1234", oauth_provider: "github")
    #     order2 = Order.new(username: "TestUser", order_name: "TestTwo", order_email: "testtest@petsy.com", oauth_uid: "5678", oauth_provider: "github")
    #     result = order2.valid?
    #     result.must_equal false
    #
    #     order2.errors.messages.must_include :username
    #   end
    #
    #   it "can create a order with an oauth_uid" do
    #     order = Order.create(oauth_uid: "11111")
    #     order.errors.messages.wont_include :oauth_uid
    #   end
    #
    #   it "is invalid without an oauth_uid" do
    #     order = Order.new
    #     result = order.valid?
    #     result.must_equal false
    #
    #     order.errors.messages.must_include :oauth_uid
    #   end
    #
    #   it "can create a order with a oauth_provider" do
    #     order = Order.create(oauth_provider: "TestGithub")
    #     order.errors.messages.wont_include :oauth_provider
    #   end
    #
    #   it "is invalid without a oauth_provider" do
    #     order = Order.new
    #     result = order.valid?
    #     result.must_equal false
    #
    #     order.errors.messages.must_include :oauth_provider
    #   end
  end

  describe "subtotal" do
    it "calculates the correct subtotal" do
      order = orders(:one)
      total = 250
      order.subtotal.must_equal total
    end

    it "calculates the correct subtotal even if the quantity is 0" do
      order = orders(:two)
      total = 0
      order.subtotal.must_equal total
    end
  end

  describe "tax" do
    it "calculates the correct amount of tax" do
      order = orders(:one)
      tax_amount = 250 * 0.095
      order.tax.must_equal tax_amount
    end

    it "calculates the correct tax even if the quantity is 0" do
      order = orders(:two)
      tax_amount = 0
      order.tax.must_equal tax_amount
    end
  end

  describe "total" do
    it "calculates the correct total" do
      order = orders(:one)
      total_amount = 250 * 1.095 + 5
      order.total.must_equal total_amount
    end

    it "calculates the correct tax even if the quantity is 0" do
      order = orders(:two)
      total_amount = 5
      order.total.must_equal total_amount
    end
  end
end
