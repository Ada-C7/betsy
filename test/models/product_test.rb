require "test_helper"

describe Product do

  describe "Validation" do

    it "is invalid without a name" do
      product = products(:four)
      product.valid?.must_equal false
    end

    it "is invalid without a unique name" do
      product = products(:aliens_two)
      product.valid?.must_equal false
    end

    it "is invalid without a quantity" do
      product = products(:no_quantity)
      product.valid?.must_equal false
    end

    it "is invalid with a non-number quantity" do
      product = products(:odd_quantity)
      product.valid?.must_equal false
    end

    it "is invalid without a price" do
      product = products(:no_price)
      product.valid?.must_equal false
    end

    it "is invalid with a non-numerical price" do
      product = products(:bad_price)
      product.valid?.must_equal false
    end

    it "is invalid with a negative price" do
      product = products(:mean_price)
      product.valid?.must_equal false
    end

    it "is invalid without a category" do
      product = products(:no_category)
      product.valid?.must_equal false
    end
  end



  describe "relations" do

    it "has one merchant (belongs to a merchant)" do
      product = products(:one)
      product.merchant.nil?.must_equal false
    end

    it "can find a merchant's name through the relationship" do
      product = products(:one)
      product.merchant.name.must_equal "Marisol"
    end

    it "can be found through the merchant's information" do
      merchant = merchants(:one)
      merchant.products.find_by(name:"aliens").class.must_equal Product
    end
    #Order-Products class has not been built out. Will test more after
  end


  describe "model methods " do
    it "can filter products by merchant" do
        all = Product.by_merchant(322419810)

        Merchant.find(all[0].merchant_id).must_be_instance_of Merchant
        Merchant.find(all[0].merchant_id).id.must_equal 322419810
    end


      it "returns an array of a single category type" do
        a= Product.first
        b = categories(:one)
        a.add_category(b.id)
       filtered_products =  Product.by_category(b.id)
    

       filtered_products[0].must_be_instance_of Product
       filtered_products.length.must_equal Category.find(b.id).products.length

      end

    end

end
