require "test_helper"

describe Product do

  describe "relations" do
    it "product has a merchant" do
       product = products(:product1)
       product.must_respond_to :merchant
       product.merchant.must_be_kind_of Merchant
    end

    it "product has many reviews" do
      product = products(:product1)
      product.must_respond_to :reviews
      product.reviews.each do |review|
        review.must_be_kind_of Review
      end
    end
    # it "has many productorders" do
    #
    # end
  end # END of describe "relations"

  describe "validations" do
    let (:merchant) {merchants(:merchant1)}
    it "requires a name" do
      product = Product.new(price: 7.30, merchant: merchant)
      product.valid?.must_equal false
      product.errors.messages.must_include :name
    end

    it "name must be unique" do
      product = products(:product1)
      puts product.name
      new_product = Product.new(name: "Food1", price: 7.30,  merchant: merchant)
      new_product.valid?.must_equal false
      new_product.errors.messages.must_include :name
    end

    it "requires a price" do
      product = Product.new(name: "Bob",merchant: merchant)
      product.valid?.must_equal false
      product.errors.messages.must_include :price
    end
  end # END of describe "validations"

  describe "average_rating" do
    it "must calculate average" do
      product = products(:product1)
      avg = (5+3+2)/3.0
      avg = avg.round(1)
      product.average_rating.must_equal avg
    end

    it "must return a dash if there are no ratings" do
      product = products(:product3)
      product.average_rating.must_equal "-"
    end
  end # END of describe "average_rating:

  describe "status_change" do
    it "must update status to passive if active" do
      product = products(:product1)
      product.status_change
      product.status.must_equal "passive"
    end

    it "must update status to active if passive" do
      product = products(:product1)
      product.status_change
      product.status.must_equal "passive"
      product.status_change
      product.status.must_equal "active"
    end
  end # END of describe "average_rating:


end # END of describe Product
