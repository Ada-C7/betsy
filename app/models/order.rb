class Order < ApplicationRecord
  has_many :order_products
  has_many :products, through: :order_products

  validates :status,  presence: true,
  inclusion: { in: %w(pending paid complete cancelled) }
  scope :by_status,-> (status){ where(:status => status) }

  # Only needed if reqirements include that an order must have at least one OrderProduct
  # validates :order_products,  presence: true

  with_options({if: :is_paid?}) do |order|

    order.validates :email, presence: true
    order.validates :mailing_address, presence: true
    order.validates :card_name, presence: true
    order.validates :credit_card, presence: true
    order.validates :card_expiration, presence: true
    order.validates :cvv, presence: true
    order.validates :zip_code, presence: true
  end


  def is_paid?
    status == "paid"
  end

  def last_four
    num = self.credit_card.length - 4
    return self.credit_card[num..-1]
  end

  def total_price
    op = OrderProduct.where(order_id: self.id)
    total = 0.0
    op.each do |product|
      total += product.subtotal
    end
    return total
  end


  def merchant_partial_order(merchant_id)
    #returns an array of order-products whose products belong to the given merchant
    all_order_products = OrderProduct.where(order_id: self.id)
    my_order_products = all_order_products.select { |order_product| order_product.product.merchant_id == merchant_id}
    return my_order_products
  end


  def merchant_subtotal(merchant_id)
    total = 0.0
    merchant_partial_order(merchant_id).each do |order_product|
      total += order_product.subtotal
    end
    return total
  end

  def merchant_shipping_required?(merchant_id)
    to_ship = self.merchant_partial_order(merchant_id).select {|order_product| order_product.status == "not shipped"}
    if to_ship.empty?
      return false
    else
      return true
    end
  end


  def can_cancel?
    if (self.status == "complete") || (self.status == "cancelled")
      return false
    else
      shipped = self.order_products.select {|op|op.status == "shipped"}
      if !shipped.empty?
        return false
      else
        return true
      end
    end
  end


  def complete?
    number_shipped = 0
    self.order_products.each do |op|
      if op.status == "shipped"
        number_shipped += 1
      end
    end
    if number_shipped == self.order_products.count
      self.status = "complete"
      self.save
    end
  end

end
