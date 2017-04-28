require "test_helper"

describe Merchant do
  # let(:merchant) { Merchant.new }

  describe 'validations on merchant' do
    it 'requires a username to be valid' do
      #merchant with no username is bad
      merchant = Merchant.new(email: 'hey@ada.org', uid: 19, provider: "hi")
      merchant.valid?.must_equal false
      merchant.errors.messages.must_include :username
      #merchant with username is good
      merchants(:dan).valid?.must_equal true
      merchants(:dan).errors.messages.wont_include :username
    end

    it 'requires a unique username to be valid' do
      dan = merchants(:dan)
      user = Merchant.new(username: 'dan', email: 'ho@ada.org', uid: 23, provider: "gg")
      result = user.save
      result.must_equal false
      user.errors.messages.must_include :username
    end

    it 'requires an email address to be valid' do
      merchant = Merchant.new(username: 'sai', uid: 87, provider: "peeves")
      merchant.valid?.must_equal false
      merchant.errors.messages.must_include :email

      merchants(:dan).valid?.must_equal true
      merchants(:dan).errors.messages.wont_include :email
    end

    it 'requires a unique email address to be valid' do
      dan = merchants(:dan)

      user = Merchant.new(username: 'sai', email: 'dan@ada.org', uid: 17, provider: "lal")
      result = user.save
      result.must_equal false
      user.errors.messages.must_include :email
    end
  end

  describe 'relationships for merchant' do
    it "can have 0 products" do
      #has no products
      sam = merchants(:sam)
      sam.valid?.must_equal true
    end

    it "can have 1 product" do
      rory = merchants(:rory)
      rory.valid?.must_equal true
      rory.products.length.must_equal 1
    end

    it "can have more than 1 product" do
      dan = merchants(:dan)
      dan.valid?.must_equal true
      dan.products.length.must_equal 10
    end

    it "products can't belong to more than one merchant" do
      rory = merchants(:rory)
      rory.valid?.must_equal true

      orange2 = products(:orange2)
      orange2.merchant = merchants(:miles)
      orange2.valid?.must_equal false
    end

  end

end
