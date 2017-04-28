require "test_helper"

describe OrdersController do


  it "should create an order" do
    proc {
    Order.create
  }.must_change "Order.count", 1
  end

  it "should show an individual product" do
    get product_path(orderitems(:one).product.id)
    must_respond_with :success
  end


end
