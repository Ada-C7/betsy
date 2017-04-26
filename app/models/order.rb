class Order < ApplicationRecord
  has_many :product_orders
  has_many :products, through: :product_orders

  validates :customer_name, presence: true, on: :update
  validates :customer_address, presence: true, on: :update
  validates :customer_email, presence: true, on: :update
  validates :credit_card_number, presence: true,
                               numericality: { only_integer: true },
                               length: { is: 16 }, on: :update
  # validates :status, inclusion: { in: %w(pending, paid, shipped) }
  # before_save :update_total

  def calculate_totals
    product_orders = self.product_orders
    subtotal = 0
    product_orders.each do |item|
      product = item.product
      subtotal += (product.price * item.quantity)
    end
    self.subtotal = subtotal
    self.tax = subtotal * 0.098
    self.total = subtotal + self.tax
    # self.save
  end
end
