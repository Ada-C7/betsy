require "test_helper"

describe ProductCategory do
  let(:category) { Category.create(name: "food")}
  let(:product) { Product.create(name: "table", price: 23, photo_url: "ew", description: "wqwq", stock: 32, merchant: Merchant.new)}
  it "can be created with all attributes" do
    pk = ProductCategory.create(category: category, product: product)
    result = pk.valid?
    result.must_equal true
  end

  it "cannot be created without category" do
    pk = ProductCategory.create( product: product)
    result = pk.valid?
    result.must_equal false
  end

  it "cannot be created without product" do
    pk = ProductCategory.create( category: category)
    result = pk.valid?
    result.must_equal false
  end
end
