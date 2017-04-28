class Product < ApplicationRecord
  belongs_to :merchant
  has_many :reviews
  has_many :product_order
  has_many :orders, through: :product_order
  has_and_belongs_to_many :categories

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :inventory, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true

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
      return ["Deactivate", "This product is currently active and will show up on NomNomazons pages."]
    else
      return ["Activate", "This product is currently passive and will NOT show up on NomNomazons pages."]
    end
  end

  def check_image
    if image == nil
      update_attributes(image:  "NomNom.png")
    elsif image.class == String && image.length == 0
      update_attributes(image:  "NomNom.png")
    end
  end

  # def sold_items
  #
  # end
  #
  # def earnings
  #
  # end

end # END of class Product
