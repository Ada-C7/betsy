class OrderProduct < ApplicationRecord
  belongs_to :product, foreign_key: "product_id"
  belongs_to :order, foreign_key: "order_id"
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :product_id, :order_id, presence: true
end
