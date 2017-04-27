class Order < ApplicationRecord
  has_many :product_orders
  has_many :products, through: :product_orders

  validates_presence_of :customer_name, on: :update, message: "Please enter a name"
  validates_format_of :customer_email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
                              on: :update,
                              message: "Please enter a valid email Ex: abc@host.com"
  validates_presence_of :customer_address, on: :update, message: "Please enter an address"
  validates_presence_of :customer_city, on: :update, message: "Please enter a city"
  validates_presence_of :customer_state, on: :update, message: "Please enter a state"
  validates_presence_of :customer_zipcode, on: :update, message: "Please enter a zipcode"
  validates_presence_of :customer_email, presence: true, on: :update, message: "Please enter an email"
  validates :credit_card_number, presence: { message: "Please enter a credit card number" },
                               numericality: { message: "Credit card must be a 16 digit number" },
                               length: { is: 16, message: "Credit card must be a 16 digit number" },
                               on: :update
  # validates :status, inclusion: { in: %w(pending, paid, shipped) }
  # before_save :update_total

  def calculate_totals
    product_orders = self.product_orders
    subtotal = 0
    product_orders.each do |item|
      product = item.product
      subtotal += (product.price * item.quantity)
    end
    self.subtotal = subtotal
    self.tax = (subtotal * 0.098).round(2)
    self.total = subtotal + self.tax
    # self.save
  end
end
