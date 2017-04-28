class Order < ApplicationRecord
  has_many :order_items
  # Removing this to solve logic problem
  # validates_presence_of :order_items




  def total
    total = 0.00
    #accesses the subtotal of each of the order items
    order_items.each do |item|
      total += item.subtotal
    end
    return total.round(2)
  end


  def products
    items = order_items
    products = items.map { |item| item.product }
    return products
  end

  def merge_pending_orders(new_order)
    new_order.order_items.each do |item|
      item.order_id = self.id
      item.save
    end
  end

end
