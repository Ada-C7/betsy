class Review < ApplicationRecord
  belongs_to :product

  validates :rating
end
