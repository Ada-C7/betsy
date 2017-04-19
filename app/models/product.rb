class Product < ApplicationRecord
  belongs_to :merchant
  has_many :order_products
  has_many :orders, through: :order_products
  has_many :reviews
  has_many :product_categories
  has_many :categories, through: :product_categories
end
