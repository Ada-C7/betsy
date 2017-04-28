class Product < ApplicationRecord
  belongs_to :merchant
  has_many :order_products
  has_many :orders, through: :order_products
  has_many :reviews
  has_many :product_categories
  has_many :categories, through: :product_categories

  scope :highest_rated, -> { where("products.id in (select product_id from reviews)").group('products.id, products.name').joins(:reviews).order('AVG(reviews.rating) DESC').limit(6)}

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }

  # validates :stock, presence: true,  numericality: true
  validate :must_have_one_category


  def must_have_one_category
    errors.add(:error, 'You must select at least one category') if self.categories.blank?
  end

  def self.search(search)
    where("name ILIKE ? OR description ILIKE ?", "%#{search}%", "%#{search}%")
  end

  def average_rating
    average = 0.0
    count = Review.where(product_id: self.id).length
    Review.where(product_id: self.id).each do |review|
      average += review.rating
    end
    if count == 0
      return  "Not rated yet"
    else
      return (average/count).round(2)
    end
  end

  def allowed_access?(user)
    if user != nil && self.merchant_id == user.id
      return true
    else
      return false
    end
  end
end
