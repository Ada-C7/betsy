require "test_helper"

describe Category do
  let(:category) { categories(:comfy) }

  # 2+ tests for each validation on a model
  describe "validations" do
    it "is valid with a unique name" do
      category.valid?
      category.errors.messages[:name].must_equal []
    end

    it "is invalid without a name" do
      category = Category.create(name: nil)
      category.valid?.must_equal false
      category.errors.messages.must_include :name
    end

    it "is invalid without a unique name" do
      category = Category.create(name: "soft n comfortable")
      category.valid?.must_equal false
      category.errors.messages.must_include :name
    end
  end

  describe "relationships" do
    it "returns an array of products" do
      category.products.each do |product|
        product.must_be_instance_of Product
        product.product.must_equal category
      end
    end
  end

end
