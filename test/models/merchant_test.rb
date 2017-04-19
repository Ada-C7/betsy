require 'test_helper'

describe Merchant do

  describe "validations" do
    it "requires a username" do
      Merchant.new.valid?.must_equal false
      merchant.errors.messages.must_include :username
    end

    it "requires a unique username" do
      merchants(:alice)
      merchant_bad = Merchant.new(username: "alice")
      merchant_bad.valid?.must_equal false
    end

    it "requires a email" do #success case

    end

    it "requires a unique email" do #failure case
      merchants(:alice)
      merchant_bad = Merchant.new(email: "alice@domainname.org")
      merchant_bad.valid?.must_equal false
    end
  end

  describe "relations"do
    it "has a list of products" do
    end
  end
end
