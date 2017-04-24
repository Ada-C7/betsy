class Order < ApplicationRecord
  has_many :order_products
  has_many :products, through: :order_products

  validates :status,  presence: true,
  inclusion: { in: %w(pending paid complete cancelled) }

 # Only needed if reqirements include that an order must have at least one OrderProduct
 # validates :order_products,  presence: true

  with_options({if: :is_paid?}) do |order|

    order.validates :email, presence: true
    order.validates :mailing_address, presence: true
    order.validates :card_name, presence: true
    order.validates :credit_card, presence: true
    order.validates :cvv, presence: true
    order.validates :zip_code, presence: true
  end


  def is_paid?
    status == "paid"
  end



  def total_price
    op = OrderProduct.where(order_id: self.id)
    total = 0.0
    op.each do |product|
      total += product.subtotal
    end
    return total
  end

end
