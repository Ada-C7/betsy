class Order < ApplicationRecord
  has_many :productorders
  # has_many :products, through: :productorders
  has_and_belongs_to_many :products
end
