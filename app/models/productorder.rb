class Productorder < ApplicationRecord
  belongs_to :product
  belongs_to :order

  def self.add_product(product_id, order_id)
    product_order = Productorder.new
    product_order.products_id = product_id
    product_order.orders_id = order_id
    product_order.quantity = 1
    return product_order
  end
end
