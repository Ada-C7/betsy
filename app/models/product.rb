class Product < ApplicationRecord
  belongs_to :merchant
  has_many :reviews
  has_many :productorders
  has_many :orders, through: :productorders

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :inventory, presence: true, numericality: { greater_than: -1 }

  def average_rating
    array_of_ratings = reviews.all.collect {|t| t.rating}.select(&:present?)
    if array_of_ratings != []
      avg = array_of_ratings.sum.to_f/array_of_ratings.length
      return avg.round(1)
    else
      return "-"
    end
  end

  def status_change
    if status == "active"
      update(status: "passive")
    else
      update(status: "active")
    end
  end

  def status_info
    if status == "active"
      return ["Passivate", "This product is currently active and will show up on NomNomazons pages."]
    else
      return ["Activate", "This product is currently passive and will NOT show up on NomNomazons pages."]
    end
  end

end # END of class Product
