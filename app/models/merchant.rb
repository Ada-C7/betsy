class Merchant < ApplicationRecord
  has_many :products
  has_many :order_products, through: :products

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

  # def total_revenue
  #   products = Product.where(merchant_id: self.id)
  #   total = 0.0
  #   products.each do |product|
  #     product.orders.each do |order|
  #       total += order.total_price
  #     end
  #   end
  #   return total
  # end

  def total_revenue
    total = 0.00
    self.my_orders.each do |order|
      total += order.merchant_subtotal(self.id)
    end
    return total
  end

  def revenue_by_status(status)
    if self.products == nil || self.my_orders == nil
      return 0.0
    end
    total = 0.00
    self.my_orders.each do |order|
      if order.status != status
        next
      else
        total += order.merchant_subtotal(self.id)
      end
    end
    return total
  end


  def my_orders
    my_orders = []
    self.products.each do |product|
      product.orders.each do |order|
        if !my_orders.include?(order)
          my_orders.push(order)
        end
      end
    end
    return my_orders
  end
end
