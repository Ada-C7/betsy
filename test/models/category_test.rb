require "test_helper"

describe Category do
  # let(:category) { Category.new }
  #
  # it "must be valid" do
  #   value(category).must_be :valid?
  # end
  describe "relations" do
    it "category has a many products" do
       category = categories(:category1)
       category.must_respond_to :products
       category.products.each do |product|
         product.must_be_kind_of Product
       end
    end
  end # END of describe "relations"

  describe "validations" do

    it "name must be present" do
      new_category = Category.new()
      new_category.valid?.must_equal false
      new_category.errors.messages.must_include :name
    end

    it "name must be unique" do
      category = categories(:category1)
      puts category.name
      new_category = Category.new(name: "meat")
      new_category.valid?.must_equal false
      new_category.errors.messages.must_include :name
    end


  end # END of describe "validations"
end
