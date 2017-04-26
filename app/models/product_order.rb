class ProductOrder < ApplicationRecord
  belongs_to :order, optional: false
  belongs_to :product, optional: false
  validates_uniqueness_of :order_id,
                          scope: [:product_id],
                          message: "This item is already in the cart"
  validate :quantity, :check_quantity

  # you should be sending argument as hash
  def self.add_product(product_id, order_id)
    product_order = ProductOrder.new
    product_order.product_id = product_id
    product_order.order_id = order_id
    product_order.quantity = 1
    return product_order
  end

  def check_quantity
    product = Product.find_by(id: self.product_id
    if product.nil? || product.inventory.nil?
      errors.add(:product_order, "This item is not available")
    elsif self.quantity > product.inventory
      errors.add(:product_order, "There is not enough stock to accommodate your order")
    end
  end
end
