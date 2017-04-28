require "test_helper"

describe OrderItemsController do

  describe "#Create" do

    it "should redirect to cart when item is created successfully" do
      post new_order_item_path(products(:watch).id), params: {order_item: {quantity: (order_items(:socks).quantity)}}
      must_respond_with :redirect
      must_redirect_to cart_path
    end

    it "should not create new orderitem if product is already in cart" do
      OrderItem.destroy_all #clear it out
      post new_order_item_path(products(:aurorahat).id),
      params: {order_item: {quantity: 1}}
      post new_order_item_path(products(:aurorahat).id), params: {order_item: {quantity: 5}}
      OrderItem.count.must_equal 1
    end

    it "should not add additional orderitem if adding same item if not over stock limit" do
      OrderItem.destroy_all #clear it out
      post new_order_item_path(products(:aurorahat).id), params: {order_item: {quantity: 1}}
      post new_order_item_path(products(:aurorahat).id), params: {order_item: {quantity: 2}}
      OrderItem.count.must_equal 1
    end

    it "should update quantity on existing item if same product and not over stock limit" do
      OrderItem.destroy_all #clear it out
      post new_order_item_path(products(:aurorahat).id), params: {order_item: {quantity: 1}}
      post new_order_item_path(products(:aurorahat).id), params: {order_item: {quantity: 2}}
      OrderItem.first.quantity.must_equal 3
    end

    it "should not change existing orderitem if going over stock limit" do
      OrderItem.destroy_all #clear it out
      post new_order_item_path(products(:aurorahat).id), params: {order_item: {quantity: 1}}
      post new_order_item_path(products(:aurorahat).id), params: {order_item: {quantity: 5}}
      OrderItem.first.quantity.must_equal 1
    end

    it "should redirect to product page if over stock limit" do
      OrderItem.destroy_all #clear it out
      post new_order_item_path(products(:aurorahat).id), params: {order_item: {quantity: 1}}
      post new_order_item_path(products(:aurorahat).id), params: {order_item: {quantity: 5}}
      must_redirect_to product_path(products(:aurorahat).id)
    end

    it "can add a non-duplicate item" do
      OrderItem.destroy_all #clear it out
      post new_order_item_path(products(:aurorahat).id), params: {order_item: {quantity: 1}}
      post new_order_item_path(products(:umbrella).id), params: {order_item: {quantity: 1}}
      must_redirect_to cart_path
    end

    it "can add a single item for the first time" do
      OrderItem.destroy_all #clear it out
      post new_order_item_path(products(:aurorahat).id), params: {order_item: {quantity: 1}}
      must_redirect_to cart_path
    end

    it "can add a single item for the first time with no order" do
      OrderItem.destroy_all #clear it out
      post new_order_item_path(products(:aurorahat).id), params: {order_item: {quantity: 1}}
      put confirmation_path(Order.first.id), params: { order: { email: "test", name_on_cc: "test", cc_number: 3434, cc_ccv: 333, billing_zip: 34234, address: "test"}}
      post new_order_item_path(products(:aurorahat).id), params: {order_item: {quantity: 1}}
      must_redirect_to cart_path
    end

    #maybe want to add a test if it isn't created, that it
    #re-renders the product show page.  I'm not sure how to do this! Also may need to edit the controller itself

    it "should update model if data is good" do
      proc { post new_order_item_path(products(:watch).id), params: {order_item: {quantity: (order_items(:socks).quantity)} }}.must_change 'OrderItem.count', 1
    end

    it "should not update model if data is bad" do
      proc { post new_order_item_path(1), params: {order_item: {quantity: (order_items(:socks).quantity)}}}.must_change 'OrderItem.count', 0
    end

  end

  describe "#Update" do
    it "can update the quantity of a cart item" do
      OrderItem.destroy_all #clear it out
      post new_order_item_path(products(:aurorahat).id), params: {order_item: {quantity: 1}}
      patch order_item_path(OrderItem.first.id), params: {order_item: {quantity: 2}}
      OrderItem.first.quantity.must_equal 2
    end

    it "redirects to cart after updating quantity" do
      OrderItem.destroy_all #clear it out
      post new_order_item_path(products(:aurorahat).id), params: {order_item: {quantity: 1}}
      patch order_item_path(OrderItem.first.id), params: {order_item: {quantity: 2}}
      must_redirect_to cart_path
    end

    it "does not update quantity if quantity not changed" do
      OrderItem.destroy_all #clear it out
      post new_order_item_path(products(:aurorahat).id), params: {order_item: {quantity: 1}}
      patch order_item_path(OrderItem.first.id), params: {order_item: {quantity: 1}}
      OrderItem.first.quantity.must_equal 1
    end

    it "redirects to cart if quantity not valid" do
      OrderItem.destroy_all #clear it out
      post new_order_item_path(products(:aurorahat).id), params: {order_item: {quantity: 1}}
      patch order_item_path(OrderItem.first.id), params: {order_item: {quantity: 6}}
      must_redirect_to :cart
    end

    it "does not update quantity if quantity not valid" do
      OrderItem.destroy_all #clear it out
      post new_order_item_path(products(:aurorahat).id), params: {order_item: {quantity: 1}}
      patch order_item_path(OrderItem.first.id), params: {order_item: {quantity: 6}}
      OrderItem.first.quantity.must_equal 1
    end

    # not sure what this is supposed to be testing??
    it "redirects to user orders page if status is not pending" do skip
      login_user(users(:aurora))

      post new_order_item_path(products(:aurorahat).id), params: {order_item: {quantity: 1}}
      item = OrderItem.first
      item.order.status = "paid"
      patch order_item_path(OrderItem.first.id), params: {order_item: {quantity: 6}}
      must_redirect_to user_orders_path(users(:aurora).id)
    end

    # this test is not passing -- trying to get it to fail the save so the else gets triggered
    # it "redirects to cart if update doesn't save" do
    #   OrderItem.destroy_all #clear it out
    #   post new_order_item_path(products(:aurorahat).id), params: {order_item: {quantity: 1}}
    #   patch order_item_path(OrderItem.first.id), params: {order_item: {quantity: -1}}
    #   must_redirect_to :cart
    # end

  end

  describe "#Destroy" do

    it "will remove orderitem" do
      OrderItem.destroy_all #clear it out
      post new_order_item_path(products(:aurorahat).id), params: {order_item: {quantity: 1}}
      delete order_item_path(OrderItem.first.id)
      OrderItem.count.must_equal 0
    end

  end

  describe "#Cart" do

    it "should get the cart page" do
      get cart_path
      must_respond_with :success
    end

    it "Still works if no orderItems are in cart" do
      OrderItem.destroy_all
      get cart_path
      must_respond_with :success
    end

  end

end
