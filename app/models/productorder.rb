class Productorder < ApplicationRecord
  belongs_to :product
  belongs_to :order

  # validates :products_id, presence: true
  # validates :orders_id, presence: true

  def self.add_product(product_id, order_id)
    product_order = Productorder.new
    product_order.products_id = product_id
    product_order.orders_id = order_id
    product_order.quantity = 1
    return product_order if product_order.valid?
  end
end
