class Product < ApplicationRecord
  has_many :reviews
  has_many :orderedproducts
  belongs_to :merchant

  validates :name, presence: true,
                  uniqueness: true
  validates :price, presence: true,
                    numericality: { greater_than: 0 } #two decimal
  # inventory than or equal to zero, int, presence true
  validates :inventory, presence: true,
                        numericality: { only_integer: true, greater_than_or_equal_to: 0}

  validates :category, presence: true
  # photo_url -> presence or format?

  after_initialize :set_defaults, unless: :persisted?

  def self.by_category(category)
    category = category.singularize.downcase
    self.where(category: category)
  end

  private
  def set_defaults
    self.retired = false if self.retired.nil?
  end
end
#plants, planters, books, gardening,
