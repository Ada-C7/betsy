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
                            credit_card_number: "1234567890123456"
                            }
                          }
      # test all validations? this one is NO credit card
      @order_no_cc = { order: {
                        customer_name: "cynthia cobb",
                        customer_address: "123 st",
                        customer_email: "cyn@gmail.com",
                        customer_city: "seattle",
                        customer_zipcode: "12345",
                        customer_state: "WA"
                        }
                      }
      # credit card under 16
      @order_cc_short = { order: {
                            status: "pending",
                            customer_name: "cynthia cobb",
                            customer_address: "123 st",
                            customer_email: "cyn@gmail.com",
                            customer_city: "seattle",
                            customer_zipcode: "12345",
                            customer_state: "WA",
                            credit_card_number: "123456789012345",
                            }
                          }
      # credit card too long/more than 16
      @order_cc_long = { order: {
                            status: "pending",
                            customer_name: "cynthia cobb",
                            customer_address: "123 st",
                            customer_email: "cyn@gmail.com",
                            customer_city: "seattle",
                            customer_zipcode: "12345",
                            customer_state: "WA",
                            credit_card_number: "12345678901234567",
                            }
                          }
      # zip code too short
      @order_zip_short = { order: {
                            status: "pending",
                            customer_name: "cynthia cobb",
                            customer_address: "123 st",
                            customer_email: "cyn@gmail.com",
                            customer_city: "seattle",
                            customer_zipcode: "1234",
                            customer_state: "WA",
                            credit_card_number: "1234567890123456",
                            }
                          }
      # zip code too long
      @order_zip_long = { order: {
                            status: "pending",
                            customer_name: "cynthia cobb",
                            customer_address: "123 st",
                            customer_email: "cyn@gmail.com",
                            customer_city: "seattle",
                            customer_zipcode: "123456",
                            customer_state: "WA",
                            credit_card_number: "1234567890123456",
                            }
                          }
      # zip code not present
      @order_no_zip = { order: {
                            status: "pending",
                            customer_name: "cynthia cobb",
                            customer_address: "123 st",
                            customer_email: "cyn@gmail.com",
                            customer_city: "seattle",
                            customer_state: "WA",
                            credit_card_number: "1234567890123456",
                            }
                          }
      # no credit card name
      @order_no_name = { order: {
                            status: "pending",
                            customer_address: "123 st",
                            customer_email: "cyn@gmail.com",
                            customer_city: "seattle",
                            customer_zipcode: "12345",
                            customer_state: "WA",
                            credit_card_number: "1234567890123456",
                            }
                          }
      # credit card name less than two
      @order_name_short = { order: {
                            status: "pending",
                            customer_name: "c",
                            customer_address: "123 st",
                            customer_email: "cyn@gmail.com",
                            customer_city: "seattle",
                            customer_zipcode: "12345",
                            customer_state: "WA",
                            credit_card_number: "1234567890123456",
                            }
                          }
    end

    it 'updates order if given good data' do
      patch order_path(@order.id), params: @order_good_data
      order_after = Order.find_by(id: @order.id)
      order_after.status.must_equal "paid"
      session[:order_id].must_be_nil
      must_respond_with :redirect
      must_redirect_to order_confirmation_path(@order.id)
    end

    it 'returns error messages if no credit card info given' do
      patch order_path(@order.id), params: @order_no_cc
      flash[:status].must_equal :failure
      flash[:messages].must_include :credit_card_number
      must_respond_with :redirect
      must_redirect_to checkout_path
    end

    # IT credit card under 16
    it 'returns error messages if credit card number is less than 16 numbers' do
      patch order_path(@order.id), params: @order_cc_short
      flash[:status].must_equal :failure
      flash[:messages].must_include :credit_card_number
      must_respond_with :redirect
      must_redirect_to checkout_path
    end

    # IT credit card too long/more than 16
    it 'returns error messages if credit card number is greater than 16 numbers' do
      patch order_path(@order.id), params: @order_cc_long
      flash[:status].must_equal :failure
      flash[:messages].must_include :credit_card_number
      must_respond_with :redirect
      must_redirect_to checkout_path
    end

    # IT zip code too short
    it 'returns error messages if zip code is less than 5 numbers' do
      patch order_path(@order.id), params: @order_zip_short
      flash[:status].must_equal :failure
      flash[:messages].must_include :customer_zipcode
      must_respond_with :redirect
      must_redirect_to checkout_path
    end

    # IT zip code too long
    it 'returns error messages if zip code is greater than 5 numbers' do
      patch order_path(@order.id), params: @order_zip_long
      flash[:status].must_equal :failure
      flash[:messages].must_include :customer_zipcode
      must_respond_with :redirect
      must_redirect_to checkout_path
    end

    # IT zip code not present
    it 'returns error messages if zip code is greater than 5 numbers' do
      patch order_path(@order.id), params: @order_no_zip
      flash[:status].must_equal :failure
      flash[:messages].must_include :customer_zipcode
      must_respond_with :redirect
      must_redirect_to checkout_path
    end

    # IT no credit card name
    it "returns error messages if there's no credit card name" do
      patch order_path(@order.id), params: @order_no_name
      flash[:status].must_equal :failure
      flash[:messages].must_include :customer_name
      must_respond_with :redirect
      must_redirect_to checkout_path
    end

    # IT credit card name less than two
    it "returns error messages if credit card name less than two characters" do
      patch order_path(@order.id), params: @order_name_short
      flash[:status].must_equal :failure
      flash[:messages].must_include :customer_name
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
