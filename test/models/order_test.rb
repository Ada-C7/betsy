require "test_helper"

describe Order do

  it "has many order products" do
    ar = Order.reflect_on_association(:order_products)
    ar.macro.must_equal :has_many
  end

  describe "validations" do  #for now skipping but will put in a filter to enact the validations after everything is going through.
    it "requires a name" do
      order = Order.create
      result = order.valid?
      result.must_equal false
      order.errors.messages.must_include :name
    end

    it "requires a email" do
      order = Order.create
      result = order.valid?
      result.must_equal false
      order.errors.messages.must_include :email
    end

    it "requires an address" do
      order = Order.create
      result = order.valid?
      result.must_equal false
      order.errors.messages.must_include :address
    end

    it "requires a cc_name" do
      order = Order.create
      result = order.valid?
      result.must_equal false
      order.errors.messages.must_include :cc_name
    end

    it "requires a cc_expiration" do
      order = Order.create
      result = order.valid?
      result.must_equal false
      order.errors.messages.must_include :cc_expiration
    end

    it "requires a cc_cvv" do
      order = Order.create
      result = order.valid?
      result.must_equal false
      order.errors.messages.must_include :cc_cvv
    end

    it "requires a zip_code" do
      order = Order.create
      result = order.valid?
      result.must_equal false
      order.errors.messages.must_include :zip_code
    end
  end

  describe "show products" do
    it "returns a product name" do
      order = orders(:one)
      #I think I have to create an order that also has
      #order products tied to it, then see if the order product
      #winds up returning a product name.
    end
  end

  describe "subtract_inventory" do
    it "subtracts the quanity of product in order from product quantity" do
      #TODO finish this test !
      # pdt = products(:one)
      # order =
      # Order.subtract_inventory(pdt.id)
      # pdt.quantity.must_equal 2
      a = order_products(:one)
      b = orders(:one)
      b.subtract_inventory(b.id)
    end
  end
#   a= Product.first
# b = categories(:one)
# a.add_category(b.id)
# filtered_products =  Product.by_category(b.id)
#
#
# filtered_products[0].must_be_instance_of Product
# filtered_products.length.must_equal Category.find(b.id).products.length
#
# end

  describe "subtotal" do
    it "sums up the total of the order products" do
      # product = Product.new
      # order_product = Order_product.new
      # order = Order.new
      # ---------------------
      # order = Order.new
      # order = { order: { name: "Benjamin Franklin", status: "paid", email: "bennyfranklin@gmail.com", address: "990 fremont", cc_name: "Benjamin Franklin", cc_number: 102999203, cc_expiration: "1772/02", cc_cvv: 802, zip_code: 99201 } }
      # order.order_products = { order_products: { id: 1, product_id: 1, quantity: 1, order_id: 1 }, { id: 2, product_id: 1, quantity: 1, order_id: 1 } }
    end
  end

end
