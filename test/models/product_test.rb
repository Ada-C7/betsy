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
      new_product = Product.new(name: "Food1", price: 7.30,  merchant: merchant, status: "passive")
      new_product.valid?.must_equal false
      new_product.errors.messages.must_include :name
    end

    it "requires a price" do
      product = Product.new(name: "Bob",merchant: merchant, status: "passive")
      product.valid?.must_equal false
      product.errors.messages.must_include :price
    end

    it "requires a status" do
      product = Product.new(name: "Bob", price: 7.30, merchant: merchant)
      product.valid?.must_equal false
      product.errors.messages.must_include :status
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
  end # END of describe "status_change"


  describe "status_info" do
    it "must return an array for both casesin the if else statement" do
      product1 = products(:product1)
      product1.status_info.must_be_kind_of Array
      product4 = products(:product4)
      product4.status_info.must_be_kind_of Array
    end

    it "first element in return array is Deactivate if the product status is active and vise versa" do
      product1 = products(:product1)
      product1.status_info[0].must_equal "Deactivate"
      product4 = products(:product4)
      product4.status_info[0].must_equal "Activate"
    end
  end # END of describe "status_info"

  describe "check_image" do
    it "updates with NomNom.png if image is lacking 1" do
      product5 = products(:product5)
      product5.check_image
      product5.image.must_equal "NomNom.png"

    end

    it "updates with NomNom.png if image is lacking 2" do
      product5 = products(:product5)
      product5.update_attributes(image: "")
      product5.check_image
      product5.image.must_equal "NomNom.png"
    end
  end # END of describe "status_info"

  describe "remove_inventory" do
    #product1 has 3 in inventory
    let(:product) { products(:product1) }
    it "must decrease inventory by a certain quanitity" do
      inventory_before = product.inventory
      product.remove_inventory(1)
      prod_after = Product.find(product.id)
      prod_after.inventory.must_equal inventory_before - 1
    end

    it "will not decrease inventory below inventory amount" do
      inventory_before = product.inventory
      product.remove_inventory(inventory_before + 1)
      prod_after = Product.find(product.id)
      prod_after.inventory.must_equal inventory_before
    end

    it "will decrease inventory to zero" do
      inventory_before = product.inventory
      product.remove_inventory(inventory_before)
      prod_after = Product.find(product.id)
      prod_after.inventory.must_equal 0
    end
  end # END of describe remove_inventory

  describe "self.newest_products" do
    before do
      @merchant = merchants(:merchant1)
      Product.create(name: "Yummy Salad",
                                      price: 5.50,
                                      description: "Bomb diggity",
                                      image: "NomNom.png",
                                      inventory: 5,
                                      status: "active",
                                      merchant_id: @merchant.id)
    end

    it "lists the newest product first" do
      newest_prod = Product.find_by(name: "Yummy Salad")
      Product.newest_products.must_include newest_prod
    end
  end

  describe "self.highest_scored_products" do
    let(:highest_product) { products(:product2) }
    let(:no_review_product) { products(:product3) }

    it "lists the highest rated product first" do
      highest_products = Product.highest_scored_products
      highest_products.must_include highest_product
      highest_products.wont_include no_review_product
      # top = highest_product.highest_scored_products
      # top.must_equal product2
    end

    it "does not show products if none are rated" do
      Product.destroy_all
      Product.highest_scored_products.empty?.must_equal true
    end
  end
end # END of describe Product
