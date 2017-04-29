class ProductOrder < ApplicationRecord
  belongs_to :product
  belongs_to :order

  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
end
