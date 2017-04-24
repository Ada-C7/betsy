class Order < ApplicationRecord
  has_many :order_items
  belongs_to :user, optional: true

  validates :status, presence: true
  validates :email, presence: true, format: {with: /@/}
  validates :billing_name, presence: true
  validates :address, presence: true
  validates :card_number, presence: true, length: { in: 14..19 }
  validates :card_expiration, presence: true
  validates :cvv, presence: true, length: { in: 3..4 }
  validates :zipcode, presence: true, length: { is: 5 }
end
