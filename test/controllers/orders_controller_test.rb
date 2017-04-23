require "test_helper"

describe OrdersController do

  describe 'cart' do

    setup do
      Productorder.destroy_all
      order = Order.new
      product = products(:product1)
      order_product = Productorder.new
      order_product.products_id = product.id
      order_product.orders_id = order.id
      order_product.save
    end

    it 'returns the cart page' do
      Productorder.count.must_be :>, 0
      p Productorder.all
      get cart_path
      must_respond_with :success
    end

    it 'returns the cart page even when there are no items to display' do
      Productorder.destroy_all
      get cart_path
      must_respond_with :success
    end
  end

  # describe ''
end
