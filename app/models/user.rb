class User < ApplicationRecord
  has_many :products
  has_many :orders
  has_many :order_items, through: :products

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  def self.create_from_github(auth_hash)
    user = User.new(
      username: auth_hash["info"]["name"],
      provider: auth_hash["provider"],
      uid: auth_hash["uid"],
      email: auth_hash["info"]["email"]
    )

    user.save ? user : nil
  end

  def image_url
    @image_url ||= 'default-user-image.png'
  end

  def order_count
    order_items.map { |order_item| order_item.order }.uniq.count
  end

  def total_revenue
    order_items.map { |order_item| order_item.subtotal }.inject(:+)
  end

  def order_count_by_status(status)
    order_items.map { |order_item|
      # pulls the order if the order status matches the target
      order_item.order if order_item.order.status == status
    # counts the number of unique orders, excluding nil values (created by conditional above)
    }.compact.uniq.count
  end

  def revenue_by_order_status(status)
    order_items.map { |order_item|
      # pulls the order_item subtotal if the order status matches the target
      order_item.subtotal if order_item.order.status == status
    # removes nil values from the array and sums the subtotals together
    }.compact.inject(:+)
  end

end
