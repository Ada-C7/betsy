require "test_helper"

describe Order do

  describe "validations" do
    it "does not create an order without a status" do
      order = Order.new
      order.valid?.must_equal false
      order.errors.messages.must_include :status
    end

    it "does not create an order with a status other than pending, paid, complete, or cancelled" do
      order = Order.new(status: "open")
      order.valid?.must_equal false
      order.errors.messages.must_include :status
    end

    it "successfully creates an order with a valid status " do
      order1 = Order.new(status: "pending")
      order2 = Order.new(status: "paid")
      order3 = Order.new(status: "complete")
      order4 = Order.new(status: "cancelled")

      order2.attributes ={email: "me@aol.com", mailing_address: "12 34th St", card_name: "Olga Owl", credit_card: "1234", cvv: "567", card_expiration: DateTime.now, zip_code: "12345"}

      # This must go through, so we use save!
      order1.save!
      order2.save!
      order3.save!
      order4.save!
    end


    it "successfully creates an order with a paid status and the subsequently required fields " do

      order = Order.new(status: "paid")
      order.attributes ={email: "me@aol.com", mailing_address: "12 34th St", card_name: "Olga Owl", credit_card: "1234", card_expiration: DateTime.now, cvv: "567", zip_code: "12345"}

      # This must go through, so we use save!
      order.save!
    end


    it "requires an email if status is paid" do
      order = Order.new(status: "paid")
      order.attributes ={mailing_address: "12 34th St", card_name: "Olga Owl", credit_card: "1234", card_expiration: DateTime.now, cvv: "567", zip_code: "12345"}

      order.valid?.must_equal false
      order.errors.messages.must_include :email
    end


    it "requires a mailing address if status is paid" do
      order = Order.new(status: "paid")
      order.attributes ={email: "me@aol.com", card_name: "Olga Owl", credit_card: "1234", card_expiration: DateTime.now, cvv: "567", zip_code: "12345"}

      order.valid?.must_equal false
      order.errors.messages.must_include :mailing_address
    end

    it "requires a credit card name if status is paid" do
      order = Order.new(status: "paid")
      order.attributes ={email: "me@aol.com", mailing_address: "12 34th St", credit_card: "1234", card_expiration: DateTime.now, cvv: "567", zip_code: "12345"}

      order.valid?.must_equal false
      order.errors.messages.must_include :card_name
    end

    it "requires a credit card if status is paid" do
      order = Order.new(status: "paid")
      order.attributes ={email: "me@aol.com", mailing_address: "12 34th St", card_name: "Olga Owl", card_expiration: DateTime.now, cvv: "567", zip_code: "12345"}

      order.valid?.must_equal false
      order.errors.messages.must_include :credit_card
    end

    it "requires a cvv if status is paid" do
      order = Order.new(status: "paid")
      order.attributes ={email: "me@aol.com", mailing_address: "12 34th St", card_name: "Olga Owl", credit_card: "1234", card_expiration: DateTime.now, zip_code: "12345"}

      order.valid?.must_equal false
      order.errors.messages.must_include :cvv
    end

    it "requires a zip code if status is paid" do
      order = Order.new(status: "paid")
      order.attributes ={email: "me@aol.com", mailing_address: "12 34th St", card_name: "Olga Owl", credit_card: "1234", card_expiration: DateTime.now, cvv: "567"}

      order.valid?.must_equal false
      order.errors.messages.must_include :zip_code
    end
  end

  describe "total_price" do
    it "calculates total price of order "do

    product1 = products(:owl1)
    product2 = products(:owl2)
    category = Category.create(name: "supercategory")
    pc1 = ProductCategory.create(product_id: product1.id, category_id: category.id)
    pc2 = ProductCategory.create(product_id: product2.id, category_id: category.id)
    product1.reload
    product2.reload
    order = Order.create(status: "paid", email: "new@gmail.com", mailing_address: "123 Main street",  card_name: "somebody fake",credit_card: "434338943", cvv: 434,zip_code: 43434, paid_at: DateTime.now)
    op1 = OrderProduct.create(order: order, product: product1, quantity: 10)
    op2 = OrderProduct.create(order: order, product: product2, quantity: 10)
    order.total_price.must_equal 300
  end

end

describe "relations" do
  it "has a list of order_products" do
    sophia_cart= orders(:sophia_cart)
    sophia_cart.must_respond_to :order_products
    sophia_cart.order_products.each do |order_product|
      order_product.must_be_kind_of OrderProduct
    end
  end

  it "has a list of products" do
    sophia_cart= orders(:sophia_cart)
    sophia_cart.must_respond_to :products
    sophia_cart.products.each do |product|
      product.must_be_kind_of Product
    end
  end
end


describe "scopes" do
  it "can return the orders with a particular status" do
    orders = Order.all

    orders.by_status("pending").each do |order|
      order.status.must_equal "pending"
    end
    orders.by_status("pending").count.must_equal 2
  end

  it "returns an empty relation if there are no orders with a particular status" do
    orders = Order.all
    pending_orders = orders.by_status("pending")
    pending_orders.by_status("paid").must_be_kind_of  Order::ActiveRecord_Relation
    pending_orders.by_status("paid").count.must_equal 0
  end
end

describe "model methods" do

  it "can return the last_four of a credit card number" do
    cart = orders(:sophia_cart)
    cart.last_four.must_equal "2232"
  end

  it "can return true for a paid order" do
    paid_order = orders(:order234)
    paid_order.is_paid?.must_equal true
  end

  it "can return false for an order with status other than paid" do
    not_paid_order = orders(:sophia_cart)
    not_paid_order.is_paid?.must_equal false
  end


  it "can return the correct total_price of an order" do
    order = orders(:sophia_cart)
    order.total_price.must_equal 80
  end

  it "returns 0 as the total_price of an empty order" do
    order = Order.new
    order.total_price.must_equal 0
  end

  it "returns the order products of a given merchant from an order as the merchant_partial_order" do
    order = orders(:sophia_cart)
    merchant_id = merchants(:dan).id
    order_product2 = order_products(:order_product2)
    order_product3 = order_products(:order_product3)

    order.merchant_partial_order(merchant_id).count.must_equal 2
    order.merchant_partial_order(merchant_id).must_include order_product2
    order.merchant_partial_order(merchant_id).must_include order_product3
  end

  it "returns an empty array as the as the merchant_partial_order if a given merchant has no products in an order" do
    order = orders(:sophia_cart)
    merchant_id = merchants(:ada).id
    order.merchant_partial_order(merchant_id).must_equal []
  end

  it "returns the correct merchant_subtotal for a given merchant" do
    order = orders(:sophia_cart)
    merchant_id = merchants(:dan).id
    order.merchant_subtotal(merchant_id).must_equal 70
  end

  it "returns 0 as the  merchant_subtotal if a given merchant has no products in an order" do
    order = orders(:sophia_cart)
    merchant_id = merchants(:ada).id
    order.merchant_subtotal(merchant_id).must_equal 0
  end

  it "returns true for merchant_shipping_required? if a merchant has unshipped order_products in an order" do
    order = orders(:sophia_cart)
    merchant_id = merchants(:dan).id
    order.merchant_shipping_required?(merchant_id).must_equal true
  end

  it "returns false for merchant_shipping_required? if all order_products from a merchant have been shipped" do
    order = orders(:sophia_cart)
    order.order_products.each do |order_product|
      order_product.status = "shipped"
      order_product.save
    end
    merchant_id = merchants(:dan).id
    order.merchant_shipping_required?(merchant_id).must_equal false
  end

  it "returns true for can_cancel? if a no prodcus in a paid or pending order have been shipped" do
    order = orders(:sophia_cart)
    order.status = "paid"
    order.save
    order.order_products.each do |order_product|
      order_product.status = "not shipped"
      order_product.save
    end
    order.can_cancel?.must_equal true
  end

  it "returns false for can_cancel? if ANY prodcus in a paid or pending order have been shipped" do
    order = orders(:sophia_cart)
    order.status = "paid"
    order.save
    order.order_products.each do |order_product|
      order_product.status = "not shipped"
      order_product.save
    end
    order.order_products[0].status = "shipped"
    order.order_products[0].save
    order.can_cancel?.must_equal false
  end


  it "returns false for can_cancel? if an order status is complete or canceled" do
    order = orders(:sophia_cart)
    order.status = "complete"
    order.save

    order.can_cancel?.must_equal false
    order.status = "cancelled"
    order.save
    order.can_cancel?.must_equal false
  end


  it "changed the status of an order to complete if all prodcus in an order have been shipped" do
    order = orders(:sophia_cart)
    order.status = "paid"
    order.save
    order.order_products.each do |order_product|
      order_product.status = "shipped"
      order_product.save
    end
    order.complete?
    order.status.must_equal "complete"
  end

  it "does not change the status of an order if there are ANY unshipped prodcus in the order" do
    order = orders(:sophia_cart)
    order.status = "paid"
    order.save
    order.order_products.each do |order_product|
      order_product.status = "shipped"
      order_product.save
    end
    order.order_products[0].status = "not shipped"
    order.order_products[0].save
    order.complete?
    order.status.must_equal "paid"
  end
end
end
