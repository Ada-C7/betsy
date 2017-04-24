class Merchant < ApplicationRecord
  has_many :products

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, format: /.+@.+/

  def self.from_github(auth_hash)
    merchant = Merchant.new
    merchant.username = auth_hash["info"]["nickname"]
    merchant.email = auth_hash["info"]["email"]
    merchant.oauth_id = auth_hash["uid"]
    merchant.oauth_provider = "github"
    return merchant
  end

  def total_revenue
    products = Product.where(merchant_id: self.id)
    total = 0.0
    products.each do |product|
      product.orders.each do |order|
        total += order.total_price
      end
    end
    return total
  end

end
