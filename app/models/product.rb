class Product < ApplicationRecord
  has_many :reviews
  has_many :order_items
  belongs_to :user
  has_and_belongs_to_many :categories

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :quantity, presence: true, numericality: { only_integer: true }
  validates :description, presence: true
  validates :image_url, presence: true
end
