require "test_helper"

describe OrderProductsController do

  describe "index" do
    it "gets index" do
      get order_products_path
      must_respond_with :success
    end
    it "lists all order_products" do
      OrderProduct.count.must_be :>, 0
      get order_products_path
      must_respond_with :success
    end
    it "responds successfully when there are no order_products" do
      OrderProduct.destroy_all
      get order_products_path
      must_respond_with :success
    end
  end

  # describe "new" do
  #   it "successfully loads the new orderproduct page" do
  #     get new_order_product_path
  #     must_respond_with :success
  #   end
  # end

  describe "create" do
    it "adds a orderproduct to the database" do
      order_product = {order_product: { product_id: 1, order_id: 1, quantity: 1}}
      post order_products_path, params: order_product
      must_redirect_to products_path
    end
  end

  describe "edit" do
    it "find orderproduct that exists" do
      # order_product = {order_product: { product_id: 1, order_id: 1, quantity: 1}}
      order_product = order_products(:one)
      get edit_order_product_path(order_product.id)
      must_respond_with :success

    end
  end

  describe "update" do
    it "updates the quantity of an orderproduct" do skip
      order_product = {order_product: { product_id: 1, order_id: 1, quantity: 1}}
      patch order_product_path(order_product), params: { order_product: { quantity: 10 }}
      must_redirect_to order_product_path(order_product)
      order_product.quantity.must_equal 10

    end

  end

  describe "delete" do

  end

end
