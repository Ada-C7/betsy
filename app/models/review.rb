class Review < ApplicationRecord
  validates :rating, presence: true
  validates_inclusion_of :rating, :in => 1..5

  belongs_to :product, :foreign_key => 'product_id'


end
