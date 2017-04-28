require "test_helper"

describe OrdersController do

  describe 'cart' do

    before do
      # ProductOrder.destroy_all
      order = orders(:order1)
      product = products(:product4)
      order_product = ProductOrder.new
      order_product.product_id = product.id
      order_product.order_id = order.id
      order_product.quantity = 1
      order_product.save
    end

    it 'returns the cart page' do
      ProductOrder.count.must_be :>, 0
      get cart_path
      must_respond_with :success
    end

    it 'returns the cart page when there are no items to display' do
      ProductOrder.destroy_all
      get cart_path
      must_respond_with :success
    end
  end

  describe 'add_product' do

    before do
      merchant = merchants(:two)
      @product = Product.new
      @product.name = "pizza"
      @product.price = 5.00
      @product.image = "www.google.com"
      @product.status = "pending"
      @product.merchant_id = merchant.id
      @product.inventory = 6
      @product.save
    end

    it 'generates a new product_order' do
      proc { post product_add_product_path(@product.id) }.must_change 'ProductOrder.count', +1
      must_respond_with :redirect
      must_redirect_to cart_path
    end

    it 'will not add a product if there is an error' do
      id = @product.id + 1
      before_count = ProductOrder.count
      post product_add_product_path(id)
      after_count = ProductOrder.count

      after_count.must_equal before_count
      must_respond_with :redirect
    end

    it 'will not add product if it is already in cart' do
      set_up_order(@product)
      before = ProductOrder.count
      session[:order_id].wont_be_nil
      post product_add_product_path(@product.id)
      after = ProductOrder.count
      after.must_equal before
    end
  end

  describe 'checkout' do
    it 'returns the checkout page' do
      get checkout_path
      must_respond_with :success
    end

    it 'returns the checkout page even if there are no products in cart' do
      ProductOrder.destroy_all
      get checkout_path
      must_respond_with :success
    end
  end

  # this is an integration test and here we are testing the order validations that only run on update
  describe 'update' do
    before do
      @order = Order.create
      @order_good_data = { order: {
                                  status: "pending",
                                  customer_name: "cynthia cobb",
                                  customer_address: "123 st",
                                  customer_email: "cyn@gmail.com",
                                  customer_city: "seattle",
                                  customer_zipcode: "12345",
                                  customer_state: "WA",
                                  credit_card_number: "1234567890123456",
                                  credit_card_name: "bob bob",
                                  credit_card_cvv: "123",
                                  credit_card_zipcode: "12345"
                                  }
                          }

      @order_bad_info = { order: {
                                  status: "pending",
                                  customer_name: "cynthia cobb",
                                  customer_address: "123 st",
                                  customer_email: "cyn@gmail.com",
                                  customer_city: "seattle",
                                  customer_zipcode: "12345",
                                  customer_state: "WA",
                                  credit_card_number: "1234567890123456",
                                  credit_card_name: "bob bob",
                                  credit_card_cvv: "123",
                                  credit_card_zipcode: ""
                                  }
                          }

    end

    it 'updates order if given good data' do
      patch order_path(@order.id), params: @order_good_data
      order_after = Order.find_by(id: @order.id)
      order_after.status.must_equal "paid"
      session[:order_id].must_be_nil
      flash[:partial].wont_be_nil
      must_respond_with :redirect
      must_redirect_to root_path
    end

    it 'returns error messages given' do
      patch order_path(@order.id), params: @order_bad_info
      flash[:status].must_equal :failure
      flash[:messages].wont_be_nil
      must_respond_with :redirect
      must_redirect_to checkout_path
    end
  end

  describe 'update_quantity' do
    # product 1 has 3 available in stock
    # product 2 has 5 available in stock
    before do
      # order = orders(:order2)
      product = products(:product1)
      @product_order = product_orders(:product_order2)
      @params_info = { product_id: product.id, quantity: 3 }
      @params_high_quant = { product_id: product.id, quantity: 6 }
    end

    it 'update the ProductOrder quantity' do
      patch qty_update_path(@product_order.id), params: {product_order: @params_info }
      pro_ord = ProductOrder.find_by(id: @product_order.id)
      pro_ord.quantity.must_equal 3
      must_respond_with :redirect
    end

    it 'wont update the quantity if there is not enough in stock' do
      patch qty_update_path(@product_order.id), params: { product_order: @params_high_quant }
      flash[:status].must_equal :failure
      flash[:messages].must_include :product_order
      must_respond_with :redirect
    end
  end

  describe 'remove_product' do

    before do
      @product = products(:product2)
      set_up_order(@product)
    end

    it 'removes a product from cart' do
      # use to test that session is set
      session[:order_id].wont_be_nil
      delete remove_product_path(@product.id)
      ProductOrder.find_by(order_id: session[:order_id]).must_be_nil
      must_respond_with :redirect
    end

    it 'wont do anything if there are no items in cart' do
      ProductOrder.destroy_all
      delete remove_product_path(@product.id)
      must_respond_with :redirect
    end
  end
end
