class Orderitem < ApplicationRecord
  belongs_to :order
  belongs_to :product, :foreign_key => 'product_id'

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0  }

  #WIP not actually good code yet
  # validates :enough_product_in_stock




end
