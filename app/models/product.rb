class Product < ApplicationRecord
  has_many :reviews
  has_many :order_items
  belongs_to :user
  has_and_belongs_to_many :categories
end
