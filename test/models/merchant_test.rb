require "test_helper"

describe Merchant do

  describe "relationships" do
    it "can have many products" do
      merchant = merchants(:erica)
      merchant.products.count.must_equal 2
    end

    it "can have many orders" do
      merchant = merchants(:erica)
      merchant.products.count.must_equal 2
    end
    #
    it "can access orders" do
      order_count = 1
      merchant = merchants(:erica)
      merchant.orders.count.must_equal 1
    end
  end

  describe "validations" do
    it "can create a merchant with a merchant_email" do
      merchant = Merchant.create(merchant_email: "TestEmail")
      merchant.errors.messages.wont_include :merchant_email
    end

    it "is invalid without a merchant_email" do
      merchant = Merchant.new
      result = merchant.valid?
      result.must_equal false

      merchant.errors.messages.must_include :merchant_email
    end

    it "is invalid with a duplicate merchant_email" do
      merchant1 = Merchant.create(username: "TestUser", merchant_name: "Test", merchant_email: "test@petsy.com", oauth_uid: "1234", oauth_provider: "github")
      merchant2 = Merchant.new(username: "Lala", merchant_name: "TestTwo", merchant_email: "test@petsy.com", oauth_uid: "5678", oauth_provider: "github")
      result = merchant2.valid?
      result.must_equal false

      merchant2.errors.messages.must_include :merchant_email
    end

    it "can create a merchant with a username" do
      merchant = Merchant.create(username: "TestUser")
      merchant.errors.messages.wont_include :username
    end

    it "is invalid without a username" do
      merchant = Merchant.new
      result = merchant.valid?
      result.must_equal false

      merchant.errors.messages.must_include :username
    end

    it "is invalid with a duplicate username" do
      merchant1 = Merchant.create(username: "TestUser", merchant_name: "Test", merchant_email: "test@petsy.com", oauth_uid: "1234", oauth_provider: "github")
      merchant2 = Merchant.new(username: "TestUser", merchant_name: "TestTwo", merchant_email: "testtest@petsy.com", oauth_uid: "5678", oauth_provider: "github")
      result = merchant2.valid?
      result.must_equal false

      merchant2.errors.messages.must_include :username
    end

    it "can create a merchant with an oauth_uid" do
      merchant = Merchant.create(oauth_uid: "11111")
      merchant.errors.messages.wont_include :oauth_uid
    end

    it "is invalid without an oauth_uid" do
      merchant = Merchant.new
      result = merchant.valid?
      result.must_equal false

      merchant.errors.messages.must_include :oauth_uid
    end

    it "can create a merchant with a oauth_provider" do
      merchant = Merchant.create(oauth_provider: "TestGithub")
      merchant.errors.messages.wont_include :oauth_provider
    end

    it "is invalid without a oauth_provider" do
      merchant = Merchant.new
      result = merchant.valid?
      result.must_equal false

      merchant.errors.messages.must_include :oauth_provider
    end
  end
end
