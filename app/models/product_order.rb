class ProductOrder < ApplicationRecord
  belongs_to :order, optional: false
  belongs_to :product, optional: false

  def self.add_product(product_id, order_id)
    product_order = ProductOrder.new
    product_order.product_id = product_id
    product_order.order_id = order_id
    product_order.quantity = 1
    return product_order
  end
end
