class User < ApplicationRecord
  has_many :products
  has_many :orders

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

  def order_revenue(order)
    order_items = OrderItem.where(product: products, order: order)
    # TODO: Update to subtotal method on order_item
    order_items.map { |order_item| order_item.quantity * order_item.product.price }.inject(:+)
  end

  def total_revenue
    order_items = OrderItem.where(product: products)
    # TODO: Update to subtotal method on order_item
    order_items.map { |order_item| order_item.quantity * order_item.product.price }.inject(:+)
  end

end
