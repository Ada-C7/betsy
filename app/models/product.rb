class Product < ApplicationRecord
  belongs_to :merchant
  has_many :orders, through: :orderproducts
  has_many :orderproducts
  has_many :reviews
  has_and_belongs_to_many :categories
  validates :product_name, presence: true
  validates :price, presence: true
  validates :merchant_id, presence: true
  validates :stock, presence: true

  def default_image
    if photo_url
      return photo_url
    else
      return "http://www.rawdogplus.com/wp-content/uploads/2015/05/pic-coming-soon_150x150.jpg"
    end
  end


  def avg_rating
    avg = reviews.select('avg(reviews.rating) as avg_rating').take&.avg_rating
    unless avg.nil?
      return avg.round(2)
    else
      return nil
    end
  end
end
