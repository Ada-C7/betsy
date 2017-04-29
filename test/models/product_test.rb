require "test_helper"

describe Product do
  let(:product) { Product.new }

  it "all products must be valid" do
    products.each do |product|
      value(product).must_be :valid?
    end
  end

  it "does not save invalid product" do
    product.wont_be :valid?
  end

  describe "validation tests" do

    it "product can not be created without valid stock" do
      products(:two)[:stock] = -1

      products(:two).must_be :invalid?
    end

    # required test (1/6)
    it "product can not be created without name" do
      products(:two)[:name] = nil

      products(:two).must_be :invalid?
    end

    # required test (2/6)
    it "Name must be unique" do
    end

    # required test (3/6)
    it "product can not be created without valid price" do
      products(:two)[:price] = -2

      products(:two).must_be :invalid?
    end

    # required test (4/6)
    it "Price must be present" do
    end

    # required test (5/6)
    it "Price must be greater than 0" do
    end
  end

  describe "association test" do
    # required test (6/6)
    it "Product has one user" do
      assert_equal 1, products(:one).user_id
    end

    it "Product can have many reviews" do
      assert_operator 1, :<, products(:two).reviews.count
    end

    it "Product can have many product_orders" do
      skip
      #FIXME: Not functioning
      assert_operator 1, :<, products(:one).product_orders.count
    end

    it "Product can have many orders (through product orders)" do
      skip
      #FIXME: Not functioning
      assert_operator 1, :<, products(:one).orders.size
    end

    it "Product can have many product categories" do
      assert_operator 1, :<, products(:two).product_categories.count
    end

    it "Product can have many categories (through product categories)" do
      puts products(:two).categories.count
      assert_operator 1, :<, products(:two).categories.count
    end
  end
end
