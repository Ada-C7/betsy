require "test_helper"

describe Product do
  let(:product) { products(:kidjams, :famjams, :jamjams).sample }

  # 2+ tests for each validation on a model
  describe "validations" do
    it "starts w retired set to false" do
      product.valid?
      product.errors.messages[:name].must_equal []
      product.retired.must_equal false
    end

    it "is valid with a unique name" do
      product.valid?
      product.errors.messages[:name].must_equal []
    end

    it "is invalid without a name" do
      products(:noname).valid?.must_equal false
      products(:noname).errors.messages.must_include :name
    end

    it "is invalid without a unique name" do
      products(:samename1).valid?.must_equal false
      products(:samename1).errors.messages.must_include :name

      products(:samename2).valid?.must_equal false
      products(:samename2).errors.messages.must_include :name
    end

    it "is valid with an integer quantity" do
      product.valid?
      product.errors.messages[:quantity].must_equal []
    end

    it "is invalid without a quantity" do
      products(:noquantity).valid?.must_equal false
      products(:noquantity).errors.messages.must_include :quantity
    end

    it "is invalid without a numeric quantity" do
      product = Product.create(name: "test", quantity: "a few", price: 10.0, description: "test", image_url: "test", user: users(:one))
      product.valid?.must_equal false
      product.errors.messages.must_include :quantity
    end

    it "is invalid without an integer quantity" do
      product = Product.create(name: "test", quantity: 1.5, price: 10.0, description: "test", image_url: "test", user: users(:one))
      product.valid?.must_equal false
      product.errors.messages.must_include :quantity
    end

    it "is valid with a price" do
      product.valid?
      product.errors.messages[:price].must_equal []
    end

    it "is invalid without a price" do
      products(:noprice).valid?.must_equal false
      products(:noprice).errors.messages.must_include :price
    end

    it "is invalid without a numerical price" do
      product = Product.create(name: "test", quantity: 1, price: "many bucks", description: "test", image_url: "test", user: users(:one))
      product.valid?.must_equal false
      product.errors.messages.must_include :price
    end

    it "is invalid without a numerical price greater than 0" do
      product = Product.create(name: "test", quantity: 2, price: -2.0, description: "test", image_url: "test", user: users(:one))
      product.valid?.must_equal false
      product.errors.messages.must_include :price
    end

    it "is valid with a description" do
      product.valid?
      product.errors.messages[:description].must_equal []
    end

    it "is invalid without a description" do
      products(:nodesc).valid?.must_equal false
      products(:nodesc).errors.messages.must_include :description
    end

    it "is valid with a image" do
      product.valid?
      product.errors.messages[:image_url].must_equal []
    end

    it "is invalid without a image" do
      products(:noimg).valid?.must_equal false
      products(:noimg).errors.messages.must_include :image_url
    end

    it "is valid with a user" do
      product.valid?
      product.errors.messages[:user].must_equal []
    end

    it "is invalid without a user" do
      products(:nouser).valid?.must_equal false
      products(:nouser).errors.messages.must_include :user
    end
  end


  describe "relationships" do
    # has many order_items
    it "returns an array of order_items" do
      product.order_items.each do |order_item|
        order_item.must_be_instance_of OrderItem
        order_item.product.must_equal product
      end
    end

    # belongs to user
    it "returns a user" do
      products(:jamjams).user.must_be_instance_of User
      users(:one).products.must_include products(:jamjams)
    end

    # has and belongs to many categories
    it "returns an array of categories" do
      product.categories.each do |category|
        category.must_be_instance_of Category
        category.product.must_equal product
      end
    end

    # has reviews
    it "returns an array of reviews" do
      product.reviews.each do |review|
        review.must_be_instance_of Review
        review.product.must_equal product
      end
    end

    it "returns an empty array of reviews when product deleted" do
      deleted_product = Product.create(name: "test", quantity: 11, price: 20.0, description: "test", image_url: "test", user: users(:one))
      Review.create(rating: 5, comment: "most perfect", product: deleted_product)
      deleted_product_reviews = deleted_product.reviews
      deleted_product.destroy
      deleted_product_reviews.must_be_empty
    end

    describe "methods" do

    end

  end
end
