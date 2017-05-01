class Merchant < ApplicationRecord
  has_many :products
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  def self.from_github(auth_hash)
    merchant = Merchant.new
    merchant.username = auth_hash["info"]["nickname"]
    merchant.name = auth_hash["info"]["name"]
    merchant.email = auth_hash["info"]["email"]
    merchant.oauth_uid = auth_hash["uid"]
    merchant.oauth_provider = "github"
    return merchant
  end

  def orders_by_merchant
    @orders = []
    self.products.each do |product|
      product.order_products.each do |order_product|
        @orders.push order_product.order
      end
    end
    return @orders.uniq
  end

  def total_revenue
    price = 0
    self.orders_by_merchant.each do |order|
      order.order_products.each do |order_product|
        price += (order_product.product.price)
      end
    end
    return price
  end

end
