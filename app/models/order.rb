class Order < ApplicationRecord
  has_many :productorders
  has_many :products, through: :productorders
  has_and_belongs_to_many :products

  validates :customer_name, presence: true
  validates :customer_address, presence: true
  validates :customer_email, presence: true
  validates :customer_cc_info, presence: true,
                               numericality: { only_integer: true },
                               length: { is: 16 }
  validates :status, inclusion: { in: %w(paid) }
end
