 require "test_helper"

describe OrdersController do

  describe "index" do
    it "gets index" do
      get orders_path
      must_respond_with :success
    end
  end

  describe "show" do
    it "should get show" do
      order = Order.first
      get orders_path(order)
      must_respond_with :success
    end

    it "returns product names" do

    end 
  end

  describe "new" do
    it "should get new" do
      get new_order_path
      must_respond_with :success
    end

    it "sets the status to 'pending'" do
      #TODO
    end

  end

  describe "create" do
    it "adds an order to the database" do
    start_count = Order.count
    order = { order: { name: "Benjamin Franklin", status: "paid", email: "bennyfranklin@gmail.com", address: "990 fremont", cc_name: "Benjamin Franklin", cc_number: 102999203, cc_expiration: "1772/02", cc_cvv: 802, zip_code: 99201 } }
    post orders_path, params: order
    count_end = Order.count
    count_end.must_equal start_count + 1
    end
  end

  describe "edit" do
    it 'should get edit' do
      order = orders(:one).id
      get edit_order_path(order)
      must_respond_with :success
    end
  end

  describe "update" do
    it "updates an existing order" do
      order = orders(:one)
      patch order_path(order), params: { order: { name: "Benjamin Franklin", status: "pending", email: "Benjaminfranklin@gmail.com", address: "990 fremont", cc_name: "Benjamin Franklin", cc_number: 102999203, cc_expiration: "1772/02", cc_cvv: 802, zip_code: 99201 } }
    end

    it "changes an order record in database" do
      order = orders(:one)
      order_data = {order: {name: "changed name"}}
      patch order_path(order.id), params: order_data

      # must_redirect_to order_path(order.id)
      must_redirect_to order_summary_path(order.id)
    end

    it "responds with a bad request for bad data" do
      order = orders(:one)
      order_data = {order: {name: ""}}
      patch order_path(order), params: order_data

      must_respond_with :bad_request
    end
  end

  describe "destroy" do
    it "destroys the specified record in the database" do
      order = orders(:one)
      start_count = Order.count
      delete order_path(order)
      must_redirect_to orders_path
      count_end = Order.count

      count_end.must_equal start_count - 1
    end

  describe "order_summary" do
    it "finds the correct order" do
      order = orders(:one).id
      get order_summary_path(order)
      must_respond_with :success
    end
  end

  end
end
