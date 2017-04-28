require "test_helper"

describe OrderProduct do
  let(:order) { Order.create(status: "completed")}
  let(:product) { Product.create(name: "table", price: 23, photo_url: "ew", description: "wqwq", stock: 32, merchant: Merchant.new)}

  it "can be created with all attributes" do
    op = OrderProduct.create(order: order, product: product, quantity: 2)
    result = op.valid?
    result.must_equal true
  end
  it "cannot be created without quantity" do
    op = OrderProduct.create(order: order, product: product)
    result = op.valid?
    result.must_equal false
  end
  it "cannot be created without order" do
    op = OrderProduct.create(quantity: 2, product: product)
    result = op.valid?
    result.must_equal false
  end
  it "cannot be created without product" do
    op = OrderProduct.create(quantity: 2, order: order)
    result = op.valid?
    result.must_equal false
  end

  it "quantity must be integer greater than 0" do
    op = OrderProduct.create(quantity: -3, product: product, order: order)
    result = op.valid?
    result.must_equal false
  end
  it "quantity cannot be nil" do
    op = OrderProduct.create(quantity: nil, product: product, order: order)
    result = op.valid?
    result.must_equal false
  end
  it "subtotal method should return product price * quantity" do
    op = OrderProduct.create(quantity: 10, product: product, order: order)
    result = op.subtotal
    result.must_equal 230
  end

end
