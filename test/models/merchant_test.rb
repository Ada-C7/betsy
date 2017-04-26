require "test_helper"

describe Merchant do
  describe 'validations' do
    it "requires a username" do
      a = Merchant.create!(username: "Dan", email: "222@adaworld.com")
      result = a.valid?
      result.must_equal true
    end

    it "requires a unique username" do
      username = "test username"
      merchant1 = Merchant.new(username: "username", email: "444@adaworld.com")
      merchant1.save!

      merchant2 = Merchant.new(username: "username", email: "555@adaworld.com")
      result = merchant2.save
      result.must_equal false
      merchant2.errors.messages.must_include :username
    end

    it "Can be created with email" do
      a = Merchant.create!(username: "Jamie", email: "111@adaworld.com")
      result = a.valid?
      result.must_equal true
    end

    it "email has '@' sign" do
      a = Merchant.create!(username: "Sofi", email: "333@adaworld.com")
      a.email.include? "@"
    end
  end

  describe "relations" do
    it "has a list of products" do
      dan = merchants(:dan)
      dan.must_respond_to :products
      dan.products.each do |product|
        product.must_be_kind_of Product
      end
    end


    it "has a list of order_products" do
      dan = merchants(:dan)
      dan.must_respond_to :order_products
      dan.order_products.each do |order_product|
        order_product.must_be_kind_of OrderProduct
      end
    end


  end

  describe "model methods" do
    it "can call total revenue on the orders" do
      dan = merchants(:dan)
      dan.total_revenue.must_be_kind_of Float
    end

    it "my_orders gets accurate list of orders by given merchant" do
      dan = merchants(:dan)
      dan.my_orders.must_include orders(:sophia_cart)
      dan.my_orders.count.must_equal 1
    end

    it "my_orders returns an empty array if given merchantn has no orders" do
      jamie = merchants(:jamie)
      jamie.my_orders.must_equal []

    end


  end
end
