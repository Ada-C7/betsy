require "test_helper"

describe OrdersController do
  describe "add_to_cart" do
    it "runs successfully" do
      @order = Order.create
      product_id = Product.first.id
      order_data ={
      product: {id: product_id},
      orderproduct: {quantity: 3, product_id:1}
    }
      post add_to_cart_path(product_id), params: order_data

      must_respond_with :redirect
    end


#################working on this one
    it "creates a new orderproduct" do
      strat_count = Orderproduct.count
      @order = orders(:one)
      order_id = @order.id
      product = products(:pone)
      orderproduct = orderproducts(:opone)
      order_data = {
        orderproduct: {
          product_id: product.id, quantity: 4
        }
      }
    end
  end





  # ================need session test ================
  # describe "added_to_cart" do
  #   it "runs successfully" do
  #     product_id = Product.first.id
  #     @order = Order.first
  #     session[:order_id] = @order.id
  #     get product_orders_added_to_cart_path(product_id)
  #     must_respond_with :success
  #   end
  # end
  # describe "cart" do
  #   it "runs successfully" do
  #     get cart_url(id: 1)
  #     must_respond_with :success
  #   end
  # end
  # =====================================================

  describe "update_qty" do
    it "runs successfully" do
      order = orders(:one)
      order_id = order.id
      product = products(:pone)
      orderproduct = orderproducts(:opone)
      order_data = {
        id: order.id,
        orderproduct: {id: orderproduct.id, quantity: 3, product_id: product.id}
      }

      patch update_quantity_path(order), params: order_data
      must_redirect_to cart_path(order)
    end

    it "responds with bad_request for bogus data" do
      order = orders(:one)
      order_id = order.id
      product = products(:pone)
      orderproduct = orderproducts(:opone)
      order_data = {
        id: order.id,
        orderproduct: {id: orderproduct.id, quantity: "foo", product_id: product.id}
      }

      patch update_quantity_path(order), params: order_data
      must_respond_with :bad_request

      #Make sure that what's in the database still matches what we had before
      orderproducts(:opone).quantity.must_equal orderproduct.quantity
    end


  end

  describe "remove_from_cart" do
    it "runs successfully" do
      order_id = Order.first.id
      product_id = Product.first.id
      orderproduct_id = Orderproduct.first.id
      start_count = Orderproduct.count

      order_data = {
        order_id: order_id,
        orderproduct_id: orderproduct_id
      }
      delete remove_from_cart_path(order_id, orderproduct_id)
      must_redirect_to cart_path(order_id)
      end_count = Orderproduct.count
      end_count.must_equal start_count - 1
    end

    it "returns 404 for a orderproduct that DNE" do
      start_count = Orderproduct.count
      order_id = Order.first.id
      orderproduct_id = Orderproduct.last.id + 1
      delete remove_from_cart_path(order_id, orderproduct_id)
      must_respond_with :not_found
      end_count = Orderproduct.count
      end_count.must_equal start_count
    end
  end
end
