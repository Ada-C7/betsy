class Review < ApplicationRecord
  belongs_to :product, optional: true

  validates :rating, presence: true
end
