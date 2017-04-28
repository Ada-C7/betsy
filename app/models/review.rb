class Review < ApplicationRecord
  belongs_to :product

  validates :product_id, presence: true
  validates :rating, numericality: { allow_nil: true, only_integer: true, greater_than: 0, less_than: 6 }
  #
  # def self.to_csv
  #   attributes = %w(id product_id rating review_text title )
  #   CSV.generate( headers: true ) do |csv|
  #     csv << attributes
  #
  #     all.each do |review|
  #       csv << review.attributes.values_at(*attributes)
  #     end
  #   end
  # end
end
