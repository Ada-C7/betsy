class Product < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  belongs_to :merchant
  has_many :reviews
  has_many :productorders
  has_many :orders, through: :productorders



  def average_rating
    array_of_ratings = reviews.all.collect {|t| t.rating}.select(&:present?)
    if array_of_ratings != []
      avg = array_of_ratings.sum.to_f/array_of_ratings.length
      return avg.round(1)
    else
      return "-"
    end
  end


end # END of class Product
