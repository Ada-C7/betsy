class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  has_many :products

  # def self.to_csv
  #   attributes = %w(id username email)
  #   CSV.generate( headers: true ) do |csv|
  #     csv << attributes
  #
  #     all.each do |user|
  #       csv << user.attributes.values_at(*attributes)
  #     end
  #   end
  # end

  def orders
    #user_orders = Order.where(email: email)#.where.not(status: "pending")
    user_orders = Order.where(["email = ? and status != ?", email, "pending"])
    return user_orders
  end

  def user_orders_items
    order_items = []
    if self.products.any?
      self.products.each do |product|
        if product.order_items != []
          order_items << product.order_items
        end
      end
    else
      return order_items
    end
    order_items.flatten!
    unpending_order_items = []
    order_items.each do |item|
       if item.order.status != "pending"
         unpending_order_items << item
       end
     end
    return unpending_order_items

  end

  def user_orders
      order_items = user_orders_items
      user_orders = {}
      order_items.map {|item| user_orders[item.order_id] = item.order}
      return user_orders.values
  end

  def user_status_orders(order_status = nil)
    if order_status
      return self.user_orders.select {|order| order.status == order_status }
    else
      return self.user_orders
    end
  end


  def user_total
    if self.user_orders_items != []
      total = 0.00
      self.user_orders_items.each do |item|
        if item.order.status != "pending"
          total += item.subtotal
        end
      end
      return total.round(2)
    else
      return 0
    end
  end

  def user_status_total(status)
    if self.user_orders_items != []
      total = 0.00
      self.user_orders_items.each do |item|
        if item.ship_status == status && item.order.status != "pending"
          total += item.subtotal
        end
      end
      return total.round(2)
    else
      return 0
    end
  end

  def user_purchases_total
    total = 0.00
    if self.orders != []
        self.orders.each do |order|
          if order.status != "pending"
            total += order.total
          end
      end
    end
    return total.round(2)
  end

  def self.create_from_github(auth_hash)
        user = User.new
        user.uid = auth_hash['uid']
        user.provider = auth_hash['provider']
        user.username = auth_hash['info']['nickname']
        user.email = auth_hash['info']['email']
        user.save ? user : nil
    end
end
