require "test_helper"

describe Product do
  let(:product) { Product.new }

  it "Products require a name" do
    product.valid?.must_equal false

    #hash of all message
    product.errors.messages.must_include :name
  end

  it "Products require a price" do
    product.valid?.must_equal false

    product.errors.messages.must_include :price
  end

  it "Product requires a user to create" do
    product.valid?.must_equal false

    product.errors.messages.must_include :user
  end

  it "If a name and price are given the book is valid" do
    product.name = "My awesome product"
    product.price = 12.99
    product.user = users(:aurora)

    product.errors.messages[:name].must_equal []
    product.errors.messages[:price].must_equal []
    product.errors.messages[:user].must_equal []
  end

  it "You can create a product" do
    product.name = "My awesome product"
    product.price = 12.99
    product.user = users(:aurora)

    product.valid?.must_equal true
  end

  describe "#sell_status" do
    it "returns a a string" do
      product.name = "My awesome product"
      product.price = 12.99
      product.user = users(:aurora)

      product.save
      product.sell_status.must_be_instance_of String
    end

    it "if selling_status is set to false, will return 'retired'" do
      product.name = "My awesome product"
      product.price = 12.99
      product.user = users(:aurora)

      product.save

      product.selling_status = false
      product.sell_status.must_equal "retired"
    end

    it "if selling_status is true, will return 'selling'" do
      product.name = "My awesome product"
      product.price = 12.99
      product.user = users(:aurora)

      product.save

      product.selling_status = true
      product.sell_status.must_equal 'selling'
    end

  end

end
