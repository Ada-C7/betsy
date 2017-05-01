require "test_helper"

describe OrderProduct do

  describe "associations" do
    it "belongs_to product" do
      ar = OrderProduct.reflect_on_association(:product)
      ar.macro.must_equal :belongs_to
    end

    it "belongs_to order" do
      ar = OrderProduct.reflect_on_association(:order)
      ar.macro.must_equal :belongs_to
    end
  end
  describe "validations" do
    it "quantity must be present" do
      order_product = OrderProduct.create
      result = order_product.valid?
      result.must_equal false
    end
    it "checks quantity to make sure numericality" do
      order_product = OrderProduct.create(quantity: "apple")
      result = order_product.valid?
      result.must_equal false
    end
    it "checks that quantity is greater than 0" do
      order_product = OrderProduct.create(quantity: "-1")
      result = order_product.valid?
      result.must_equal false
    end
    it "product_id must be present" do
      order_product = OrderProduct.create(quantity: 2, order_id: orders(:one).id)
      result = order_product.valid?
      result.must_equal false
      order_product.errors.messages.must_include :product_id
    end

    it "order_id must be present" do
      order_product = OrderProduct.create(quantity: 2, product_id: products(:one).id)
      result = order_product.valid?
      result.must_equal false
      # order_product.errors.messages.must_equal({})
      order_product.errors.messages.must_include :order_id
    end
  end

end
