class Product < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, uniqueness: true, numericality: { greater_than: 0 }
  belongs_to :merchant
  # has_many :reviews
  # has_many :orders, through :orderproducts

end
