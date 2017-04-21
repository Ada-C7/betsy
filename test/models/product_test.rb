require "test_helper"

describe Product do

  describe "relations" do
    it "product has a mmerchant" do
       product = products(:product1)
       puts product.name
       product.must_respond_to :merchant
       product.merchant.must_be_kind_of Merchant
    end
    #  it "product has many reviews" do
    #  end
  end # END of describe "relations"

  describe "validations" do
    it "requires a name" do
      product = Product.new(price: 7.30)
      product.valid?.must_equal false
      product.errors.messages.must_include :name
    end

    it "name must be unique" do
      product = products(:product1)
      puts product.name
      new_product = Product.new(name: "Food1", price: 7.30)
      new_product.valid?.must_equal false

    end

    it "requires a price" do
      product = Product.new(name: "Bob")
      product.valid?.must_equal false
      product.errors.messages.must_include :price
    end



  end # END of describe "validations"

end # END of describe Product
