class Merchant < ApplicationRecord
  has_many :products

  validates :username, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true

  def self.from_github(auth_hash)
    user = Merchant.new
    user.username = auth_hash['info']['nickname']
    user.oauth_uid = auth_hash['uid']
    user.email = auth_hash['info']['email']
    user.oauth_provider = 'github'
    return user
  end

  def find_orders
    orders = []
    products.each do |product|
      product.orders.each do |order|
        orders << order if order.status != "pending"
      end
    end
    orders.uniq
  end

end
