class Order < ApplicationRecord
  has_many :order_items

  validates :status, presence: true, inclusion: { in: %w(pending paid complete cancelled),
    message: "%{value} is not a valid status" }
    validates :session_id, presence: true, uniqueness: true
    validates :total, presence: true, numericality: { only_float: true, greater_than: 0 }

    def self.find_total(order_items)
      total = 0.0

      order_items.each do | item |
        total += (item.price * item.quantity)
      end
      return total
    end

    def self.change_status(order_id) # "submit order" button on cart need to be linked to this method
      order = Order.find_by_order_id(order_id)
      order.status = "paid"
      order.save

      Order.inventory_adjust(order_id)
      # if everything is valid, it should send them to the conformation.html page
    end

    def self.inventory_adjust(order_id)

      order_items = OrderItems.find_by_order_id(order_id)

      order_items.each do | order_item |
        item = Item.find_by_id(order_item.item_id)
        if order_item.quantity <= item.inventory
          item.inventory -= order_item.quantity # reduce that items inventory by one
          item.save
        else
          # TODO: handle cases where we don't have enough inventory
        end
      end
    end
end
