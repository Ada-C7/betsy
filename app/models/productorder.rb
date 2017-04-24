class Productorder < ApplicationRecord
  belongs_to :product
  belongs_to :order


  def self.add_product(product_id, order_id)
    product_order = Productorder.new
    product_order.product_id = product_id
    product_order.order_id = order_id
    product_order.quantity = 1
    return product_order
  end
end
