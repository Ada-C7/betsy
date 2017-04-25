class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def subtotal(ordered_item)
    subtotal = ordered_item.quantity * ordered_item.product.price
    return "$ #{subtotal.round(2)}"
  end
end
