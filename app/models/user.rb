class User < ApplicationRecord
  has_many :products
  has_many :orders
  has_many :order_items, through: :products

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  def self.create_from_github(auth_hash)
    User.create(
      username: auth_hash["info"]["name"],
      provider: auth_hash["provider"],
      uid: auth_hash["uid"],
      email: auth_hash["info"]["email"]
    )
  end

  def image_url
    @image_url ||= 'default-user-image.png'
  end

  def order_revenue(order)
    order_items.select { |order_item|
      order_item.order == order
    }.map { |order_item|
      order_item.subtotal
    }.inject(:+)
  end

  def total_revenue
    order_items.map { |order_item| order_item.subtotal }.inject(:+)
  end

end
