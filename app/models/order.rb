class Order < ApplicationRecord
  STATUS =  %w(pending paid complete cancelled)
  validates :status, presence: true , inclusion: { in: STATUS }
  has_many :orderitems, :dependent => :destroy

  def subtotal
    orderitems.collect { |oi| oi.valid? ? (oi.quantity * oi.product.price) : 0 }.sum
  end

end
