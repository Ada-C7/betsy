require "test_helper"

describe Merchant do

  describe 'validations' do
    let(:merchant) { Merchant.new }

    it "must create new merchant with good info" do
      merchant.username = "cynbin"
      merchant.email = "hello@gmail.com"
      merchant.first_name = "cynthia"
      merchant.last_name = "cobb"
      merchant.valid?.must_equal true
    end

    it "wont create a merchant missing a username" do
      merchant.email = "hello@gmail.com"
      merchant.valid?.must_equal false
    end

    it 'wont crate a merchant missing an email' do
      merchant.username = "cynbin"
      merchant.valid?.must_equal false
    end
  end
end
