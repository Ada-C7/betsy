class Product < ApplicationRecord
  has_many :product_orders
  # has_many :orders, through: :product_orders
  # has_many :reviews
  # has_and_belongs_to_many :orders
  belongs_to :merchant


  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }


end
