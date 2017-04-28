require "test_helper"

describe Product do
  describe "relations" do
    it "has a list of order_products" do
      product = products(:one)
      product.must_respond_to :order_products
      product.order_products.each do |order_product|
        order_product.must_be_kind_of Order_Product
      end
    end
    it "has a list of orders, through order_products" do
      product = products(:one)
      product.must_respond_to :orders
      product.orders.each do |order|
        order.must_be_kind_of Order
      end
    end
    it "has a list of reviews" do
      product = products(:one)
      product.must_respond_to :reviews
      product.reviews.each do |review|
        review.must_be_kind_of Review
      end
    end
    it "has a list of product_categories" do
      product = products(:one)
      product.must_respond_to :product_categories
      product.product_categories.each do |product_category|
        product_category.must_be_kind_of Product_Category
      end
    end
    it "has a list of categories, through product_categories" do
      product = products(:one)
      product.must_respond_to :categories
      product.categories.each do |category|
        category.must_be_kind_of Category
      end
    end
    it "has a merchant" do
      product = products(:one)
      product.merchant = merchants(:harry)
      product.must_respond_to :merchant
      product.merchant.must_be_kind_of Merchant
    end
  end
  describe "search" do
     it "return ActiveRecord Relation array" do
       Product.search("owl1").must_be_kind_of ActiveRecord::Relation
     end
     it "return products" do
       result = Product.search("owl1")
       result.each do |r|
         r.must_be_kind_of Product
       end
     end
     it "still works fine if cannot find product" do
       result = Product.search("oatmeal")
       result.must_be_kind_of ActiveRecord::Relation
     end
  end

  describe "validations" do
    it "requires a product name" do
      product = Product.new(price: 6.00, merchant_id: merchants(:harry).id)
      product.valid?.must_equal false
      product.errors.messages.must_include :name
    end
    it "requires a unique product name" do

      category = Category.create(name: "supercategory")

      product1 = products(:owl1)
      pc1 = ProductCategory.create(product_id: product1.id, category_id: category.id)
      product1.reload
      product1.save!

      product2 = Product.new(price: 6.00, name: products(:owl1).name, merchant_id: merchants(:harry).id)
      product2.valid?.must_equal false
      product2.errors.messages.must_include :name
    end

    it "requires a price" do
      product = Product.new(name: "Ginny", merchant_id: merchants(:harry).id)
      product.valid?.must_equal false
      product.errors.messages.must_include :price
    end

    it "requires the price to be a number" do
      product = Product.new(name: "Ginny", price: "potato", merchant_id: merchants(:harry).id)
      product.valid?.must_equal false
      product.errors.messages.must_include :price
    end

    it "requires the price to be higher than 0" do
      product = Product.new(name: "Ginny", price: 0, merchant_id: merchants(:harry).id)
      product.valid?.must_equal false
      product.errors.messages.must_include :price
    end

    it "won't accept a product without a merchant" do
      product = Product.new(name: "Ginny", price: 0)
      product.valid?.must_equal false
      product.errors.messages.must_include :merchant
    end
  end
end
