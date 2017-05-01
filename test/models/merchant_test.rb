require "test_helper"

describe Merchant do

  describe "associations" do
    it "has many products" do
      ar = Merchant.reflect_on_association(:products)
      expect(ar.macro) == :has_many
    end
  end
  describe "validations" do
    it "username must be present" do
      merchant = Merchant.create
      result = merchant.valid?
      result.must_equal false
      merchant.errors.messages.must_include :username
    end

    it "username must be unique" do
      merchant = Merchant.create(username:"Duplicate")
      merchant_two = Merchant.create(username:"Duplicate")
      result = merchant_two.valid?
      result.must_equal false
    end

    it "email address must be present" do
      merchant = Merchant.create
      result = merchant.valid?
      result.must_equal false
      merchant.errors.messages.must_include :email
    end

    it "email address must be unique" do
      merchant = Merchant.create(email:"Duplicate@Duplicate.com")
      merchant_two = Merchant.create(email:"Duplicate@Duplicate.com")
      result = merchant.valid?
      result.must_equal false
    end

  end
end
