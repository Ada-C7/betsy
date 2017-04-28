class Product < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :price, presence: true
  validates_numericality_of :price, greater_than: 0
  validates :quantity, presence: true
  validates_numericality_of :quantity, greater_than: 0

  belongs_to :merchant, :foreign_key => 'merchant_id'

  has_many :reviews
  has_many :orderitems
  has_and_belongs_to_many :categories

  def self.in_stock(id, quantity)
    product = Product.find(id)
    return (quantity.to_i <= product.quantity ? true : false)
  end

  def rating
    ratings = []
    self.reviews.each do |r|
      ratings << r.rating
    end
    return 0 if ratings.length == 0
    return (ratings.reduce(:+) / ratings.length)
  end

end
