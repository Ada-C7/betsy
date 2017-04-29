class Product < ApplicationRecord


    validates :stock, presence: true, numericality: { :greater_than_or_equal_to => 0 }


    validates :name, presence: true
    validates :price, presence: true, numericality: { greater_than: 0 }

    belongs_to :user
    has_many :reviews

    has_many :product_orders
    has_many :orders, through: :product_orders

    has_many :product_categories
    has_many :categories, through: :product_categories
end
