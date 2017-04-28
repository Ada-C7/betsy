require "test_helper"

describe Category do
    let(:category) { Category.new }

    #these could all be dried up a lot with fixtures

    it "is valid with a name" do
        category = Category.new
        category.name = "watches"
        result = category.valid?
        result.must_equal true
    end

    it "is invalid without a name" do
        category = Category.new
        result = category.valid?
        result.must_equal false
        category.errors.messages.must_include :name
    end

    it "is invalid if a category is not unique" do
        category_one = Category.new
        category_one.name = "fiction"
        category_one.save

        category_two = Category.new
        category_two.name = "fiction"
        category_two.save

        result = category_two.valid?
        result.must_equal false
        # category.errors.messages.must_include :name
    end

end
