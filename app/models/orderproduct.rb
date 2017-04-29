class Orderproduct < ApplicationRecord
  belongs_to :order
  belongs_to :product
  validates :quantity, numericality: { greater_than: 0, only_integer: true, }
  validates :order_id, presence: true
  validates :product_id, presence: true
end
