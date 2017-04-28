class Product < ApplicationRecord
  belongs_to :merchant
  has_many :reviews
  has_many :product_order
  has_many :orders, through: :product_order
  has_and_belongs_to_many :categories

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :inventory, presence: true, numericality: { greater_than: -1 }
  validates :status, presence: true
  validates :image, presence: true

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

  def remove_inventory(quantity)
    if inventory >= quantity
      self.inventory -= quantity
      self.save
    end
  end

  def self.newest_products
    Product.where(status: "active").order(:created_at).reverse[0..7]
  end

  def self.highest_scored_products
    products_with_averages = {}
    Product.all.each do |prod|
      average = prod.average_rating
      if average != "-"
        products_with_averages[prod] = average
      end
    end
    lowest_top_average = products_with_averages.values.sort.reverse[0..7]
    return products_with_averages.select {|prod, avg| avg >= lowest_top_average[-1] }.keys.reverse[0..7]
  end
end # END of class Product
