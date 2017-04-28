require "test_helper"

describe "Category" do
  let(:category) { Category.new(name: "blablablas") }
  let(:category_no_attributes) { Category.new }

  describe "Validation" do
    it "can be created with all attributes" do
      result = category.valid?
      result.must_equal true
    end
    it "cannot be created without attrubute name" do
      result = category_no_attributes.valid?
      result.must_equal false
      category_no_attributes.errors.messages.must_include :name
    end
    it "can be created with all attrubutes" do
      names = ['flowers', 'tables', 'pictures', "frames"]
      names.each do |name|
        c = Category.create(name: name)
        c.valid?.must_equal true
      end
    end
    it "cannot be created with invalid name" do
      names = ['ca12t', '21og', '422', "d---sdsd", nil]
      names.each do |name|
        c = Category.create(name: name)
        c.valid?.must_equal false
        c.errors.messages.must_include :name
      end
    end
    it "requires unique name" do
      name = "computers"
      a = Category.new(name: name)
      a.save!
      b = Category.new(name: name)
      b.valid?.must_equal false
      b.errors.messages.must_include :name

    end
  end

  describe "Relationship" do
    it "product has categories" do
      merchant = Merchant.create(username: "nata", email: "eew@gmail.com")
      product = Product.create(name: "table", price: 23, photo_url: "ew", description: "wqwq", stock: 32, merchant: merchant)
      product.must_respond_to :categories
      product.categories.each do |category|
        category.must_be_kind_of Category
      end
    end
    it "product has products" do
      category = Category.new(name: "name")
      category.must_respond_to :products
      category.products.each do |product|
        product.must_be_kind_of Product
      end
    end



      # it "product has categories" do
      #   c = Category.create(name: "food")
      #
      #   6.times do |i|
      #     pr = Product.create(name: "table", price: 23, photo_url: "ew", description: "wqwq", stock: 32, merchant: Merchant.new)
      #     ProductCategory.create!(category: c, product: pr)
      #   end
      #   c.products.length.must_equal 6
      #   Category.find(c.id).products.length.must_equal 6
      # end


    end

  end
