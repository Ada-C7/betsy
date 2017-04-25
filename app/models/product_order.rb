class ProductOrder < ApplicationRecord
  belongs_to :order, optional: false
  belongs_to :product, optional: false
  validates :product_id, :uniqueness => {:scope => :order_id},
                         :uniqueness => {message: "This item is already in the cart"}

  # you should be sending argument as hash
  def self.add_product(product_id, order_id)
    product_order = ProductOrder.new
    product_order.product_id = product_id
    product_order.order_id = order_id
    product_order.quantity = 1
    return product_order
  end
end
