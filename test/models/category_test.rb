require "test_helper"

describe Category do
  describe "validations" do
    it "must have a name to be valid" do
      category = categories(:nocategory)
      category.valid?.must_equal false
      category.errors.messages.must_include :name

      acceptable = categories(:one)
      acceptable.valid?.must_equal true
      acceptable.errors.messages.wont_include :name

      no_category = categories(:nocategory)
      no_category.valid?.must_equal false
      no_category.errors.messages.must_include :name
    end

    it "must have a unique name to be valid" do
      duplicate1 = categories(:duplicate1)

      new_category = Category.new(name: "headstone")
      result = new_category.save
      # result.must_equal false
      new_category.errors.messages.must_include :name
    end

  end

  describe "relations" do
    it "can access products of a category" do
      category = categories(:one)
      category.products << products(:banana)
      category.products << products(:apple)
      category.products.wont_be :empty?
      category.products.size.must_equal 2
      category.products.must_include products(:banana)
      category.products.must_include products(:apple)

    end

    it "must be empty when a category has no products" do
      noproducts = categories(:noproducts)

      noproducts.products.must_be :empty?
    end
    # in product_test: can access categories of a product
  end
end
