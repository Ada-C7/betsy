require "test_helper"

describe Product do
  describe "relations" do
    # it "product has a mmerchant" do
    #    product = products(:product1)
    #    product.must_respond_to :merchant
    #    product.merchant.must_be_kind_of Merchant
    # end
  end # END of describe "relations"

  describe "validations" do
    it "requires a name" do
      product = Product.new(price: 7.30)
      product.valid?.must_equal false
      product.errors.messages.must_include :name
    end
  end


end # END of describe Product
