class Product < ApplicationRecord
  # belongs_to :user
  # has_many_and_belongs_to :categories
  # has_many :reviews
  # has_many :order_items

  validates :name, presence: true
  # validates :user_id, presence: true
  validates :price, presence: true



end
