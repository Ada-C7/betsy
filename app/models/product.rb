class Product < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  belongs_to :merchant
  # has_many :reviews
  has_many :productorders
  has_many :orders, through: :productorders
  has_and_belongs_to_many :orders

end
