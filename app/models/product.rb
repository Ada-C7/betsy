class Product < ApplicationRecord
  belongs_to :merchant
  has_many :order_products
  has_many :orders, through: :order_products
  has_many :reviews
  has_and_belongs_to_many :categories


  validates :name, presence: true, uniqueness: true
  validates :quantity, presence: true, numericality: true
  validates :price, presence: true, numericality: {greater_than: 0}

before_save :defaults

  def defaults
    if self.img_url == nil
      self.img_url = "http://loremflickr.com/320/240/puppy"
    end
  end

  def self.by_merchant(id)
    Product.where(merchant_id: id)
  end

  def self.by_category(id)
      Product.all.select{|product| product.categories.include?(Category.find(id)) }
  end

  def add_category(id)
      self.categories << Category.find_by(id:id)
  end

  def can_edit?(current_merchant)
    if self.merchant_id == current_merchant.id
      return true
    else
      return false
    end
  end

end
