class Order < ApplicationRecord
  has_many :products, through: :productorders
end
