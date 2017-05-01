class Review < ApplicationRecord
  belongs_to :product, foreign_key: "product_id"
  validates :rating, presence: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 5 }
end
