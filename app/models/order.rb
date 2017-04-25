class Order < ApplicationRecord
  has_many :product_orders
  # has_many :products, through: :product_orders
  # has_and_belongs_to_many :products

  validates :customer_name, presence: true, on: :update
  validates :customer_address, presence: true, on: :update
  validates :customer_email, presence: true, on: :update
  validates :customer_cc_info, presence: true,
                               numericality: { only_integer: true },
                               length: { is: 16 }, on: :update
  # validates :status, inclusion: { in: %w(pending, paid, shipped) }
  
end
