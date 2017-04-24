class Order < ApplicationRecord
  has_many :orderitems, :foreign_key => 'orderitems'
  belongs_to :merchant, :foreign_key => 'merchant_id'
  belongs_to :order_status
  before_create :set_order_status
  before_save :update_subtotal

  validates :id, presence: true, uniqueness: true
  validates :session, presence: true

  def subtotal
    order_items.collect { |oi| oi.valid? ? (oi.quantity * oi.unit_price) : 0 }.sum
  end
private
  def set_order_status
    self.order_status_id = 1
  end

  def update_subtotal
    self[:subtotal] = subtotal
  end
end
