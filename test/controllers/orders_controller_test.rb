require "test_helper"

describe OrdersController do

  describe 'cart' do

    before do
      # ProductOrder.destroy_all
      order = Order.create
      product = products(:product1)
      order_product = ProductOrder.new
      order_product.product_id = product.id
      order_product.order_id = order.id
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

  describe 'add_item' do
    setup do
      @product = Product.last
    end

    it 'generates a new product_order' do
      proc { post product_add_item_path(@product.id) }.must_change 'ProductOrder.count', +1
      must_respond_with :redirect
      must_redirect_to cart_path
    end

    it 'will not add a product if there is an error' do
      id = @product.id + 1
      before_count = ProductOrder.count
      post product_add_item_path(id)
      after_count = ProductOrder.count

      after_count.must_equal before_count
      must_respond_with :redirect
    end


    # need to figure out how to set order session to test this
    # it 'will not add product if it is already in cart' do
    #   # this first should work
    #   post product_add_item_path(@product.id)
    #   before = ProductOrder.count
    #   # this second should not
    #   post product_add_item_path(@product.id)
    #   after = ProductOrder.count
    #   after.must_equal before
    # end
  end

  describe 'checkout' do

    it 'returns the checkout page' do
      get checkout_path
      must_respond_with :success
    end

    it 'return s the checkout page even if there are no products in cart' do
      ProductOrder.destroy_all
      get checkout_path
      must_respond_with :success
    end
  end

  describe 'update' do

    before do
      @order = Order.create
      @order_good_data = { order: {
                            customer_name: "cynthia cobb",
                            customer_address: "123 st",
                            customer_email: "cyn@gmail.com",
                            customer_city: "seattle",
                            customer_zipcode: "12345",
                            customer_state: "WA",
                            customer_cc_info: "1234567890123456",
                            }
                    }
      @order_bad_data = { order: {
                            customer_name: "cynthia cobb",
                            customer_address: "123 st",
                            customer_email: "cyn@gmail.com",
                            customer_city: "seattle",
                            customer_zipcode: "12345",
                            customer_state: "WA"
                            }
                    }
    end

    it 'updates order if given good data' do
      patch order_path(@order.id), params: @order_good_data
      must_respond_with :redirect
      must_redirect_to root_path
    end
    #
    it 'returns error messages if given bad payment info' do
      patch order_path(@order.id), params: @order_bad_data
      must_respond_with :redirect
      must_redirect_to checkout_path
    end
  end

  describe 'update_quantity' do

    before do
      order = orders(:order2)

      product = products(:product1)
      @product_order = product_orders(:product_order2)
      @params_info = { product_id: product.id, quantity: 3}

    end

    it 'update the ProductOrder quantity' do
      patch qty_update_path(@product_order.id), params: {product_order: @params_info }
      pro_ord = ProductOrder.find_by(id: @product_order.id)
      pro_ord.quantity.must_equal 3
      must_respond_with :redirect
    end

  end
end
