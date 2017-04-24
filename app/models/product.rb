class Product < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :order_items
  belongs_to :user
  has_and_belongs_to_many :categories

  validates :name, presence: true, uniqueness: true
<<<<<<< HEAD
=======
  validates :price, presence: true, numericality: { greater_than: 0 }
>>>>>>> master
  validates :quantity, presence: true, numericality: { only_integer: true }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :description, presence: true
  validates :image_url, presence: true
end
