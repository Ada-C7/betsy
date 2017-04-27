class Product < ApplicationRecord
  belongs_to :merchant
  has_many :reviews
  has_many :productorders
  has_many :orders, through: :productorders
  has_and_belongs_to_many :categories

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }

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

  def remove_inventory(quantity)
    self.inventory -= quantity
    self.save
  end
end # END of class Product
