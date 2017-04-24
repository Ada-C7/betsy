require "test_helper"

describe OrdersController do

  describe 'cart' do

    before do
      Productorder.destroy_all
      order = Order.new
      product = products(:product1)
      order_product = Productorder.new
      order_product.product_id = product.id
      order_product.order_id = order.id
      order_product.save
    end

    it 'returns the cart page' do
      Productorder.count.must_be :>, 0
      # p Productorder.all
      get cart_path
      must_respond_with :success
    end

    it 'returns the cart page when there are no items to display' do
      Productorder.destroy_all
      get cart_path
      must_respond_with :success
    end
  end

  describe 'add_item' do

    # there needs to be a session with order_id...
    setup do
      @product = Product.last
    end

    it 'generates a new product_order' do
      proc { post product_add_item_path(@product.id) }.must_change 'Productorder.count', +1
      must_respond_with :redirect
      must_redirect_to cart_path
    end

    # it 'will not add a product if there is an error' do
    #   p id = @product.id + 1
    #   p Productorder.all
    #   p before_count = Productorder.count
    #   post product_add_item_path(id)
    #   p after_count = Productorder.count
    #   p Productorder.all
    #   after_count.must_equal before_count
    #   # must_respond_with :bad_request
    # end
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
