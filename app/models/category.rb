class Category < ApplicationRecord
  has_many :product_categories
  has_many :products, through: :product_categories

  validates :name, presence: { message: 'Category must be presented' },
                   format: {with: /\A[a-zA-Z]+\z/, message:  "Letter only"},
                   uniqueness: { message: 'This category already exists' }

end
