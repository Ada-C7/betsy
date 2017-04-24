class Order < ApplicationRecord
  has_many :order_items
  belongs_to :user, optional: true

  validates :status, presence: true
  validates :email, presence: true, format: {with: /@/}, unless: :in_cart?
  validates :billing_name, presence: true, unless: :in_cart?
  validates :address, presence: true, unless: :in_cart?
  validates :card_number, presence: true, length: { in: 14..19 }, unless: :in_cart?
  validates :card_expiration, presence: true, unless: :in_cart?
  validates :cvv, presence: true, length: { in: 3..4 }, unless: :in_cart?
  validates :zipcode, presence: true, length: { is: 5 }, unless: :in_cart?

  def in_cart?
    status == "pending"
  end
end
