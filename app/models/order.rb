class Order < ApplicationRecord
  has_many :product_orders
  has_many :products, through: :product_orders

  validates :customer_name, presence: true, on: :update
  validates :customer_address, presence: true, on: :update
  validates :customer_email, presence: true, on: :update
  validates :customer_cc_info, presence: true,
                               numericality: { only_integer: true },
                               length: { is: 16 }, on: :update
  # validates :status, inclusion: { in: %w(pending, paid, shipped) }
  # before_save :update_total

  def update_total
    product_orders = self.product_orders
    total = 0
    product_orders.each do |item|
      product = item.product
      total += (product.price * item.quantity)
    end
    return total
  end
end
