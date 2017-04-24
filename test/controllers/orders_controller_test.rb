require "test_helper"

describe OrdersController do

  describe 'cart' do

    before do
      ProductOrder.destroy_all
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
  end

  describe 'checkout' do

    it 'sets current_order status to paid if given payment' do

    end

    it 'saves the order in the db if given good payment' do
      # or should the order be saved and this will update the order...
    end

    it 'returns error messages if given bad payment info' do

    end

    it 'resets the order session if payment is good' do

    end

  end
end
