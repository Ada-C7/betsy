require "test_helper"

describe Category do
  let(:category) { Category.new }

  it "all categories must be valid" do
    categories.each do |category|
      value(category).must_be :valid?
    end
  end

  describe "validation tests" do
    it "new category can not be created a without unique name" do
      category_copy = category.dup
      proc { category_copy.save! }.must_raise("Category name must be unique.")
      category_copy.errors.must_include(:name)
    end

    it "new category can be created with a unique name" do
      # TODO: Add fixture
      category[:name] = "unique"
      category.save

      category.wont_be_nil
    end
  end

  describe "associations test" do
    it "#product_categories - recognizes the correct number" do
      assert_equal 2, categories(:one).product_categories.size
    end
  end
end
