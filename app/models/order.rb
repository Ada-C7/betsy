class Order < ApplicationRecord
  has_many :product_orders
  # has_many :products, through: :product_orders
  # has_and_belongs_to_many :products

  validates_presence_of :customer_name, on: :update, message: "Please enter a name"
  validates_format_of :customer_email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
                              on: :update,
                              message: "Please enter a valid email Ex: abc@host.com"
  validates_presence_of :customer_address, on: :update, message: "Please enter an address"
  validates_presence_of :customer_city, on: :update, message: "Please enter a city"
  validates_presence_of :customer_state, on: :update, message: "Please enter a state"
  validates_presence_of :customer_zipcode, on: :update, message: "Please enter a zipcode"
  validates_presence_of :customer_email, presence: true, on: :update, message: "Please enter an email"
  validates :customer_cc_info, presence: { message: "Please enter a credit card number" },
                               numericality: { message: "Credit card must be a 16 digit number" },
                               length: { is: 16, message: "Credit card must be a 16 digit number" },
                               on: :update

  # validates :status, inclusion: { in: %w(pending, paid, shipped) }

end
