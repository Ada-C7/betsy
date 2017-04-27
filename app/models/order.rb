class Order < ApplicationRecord
  has_many :product_orders
  has_many :products, through: :product_orders

  validates :customer_name,
            presence: { message: "Please enter a first and last name" },
            length: { minimum: 2, message: "Name must be greater than one character" },
            on: :update

  validates :customer_email,
            presence: { message: "Please enter an email" },
            format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
            message: "Please enter a valid email Ex: abc@host.com" },
            on: :update

  validates :customer_address,
            presence: { message: "Please enter an address"},
            length: { minimum: 3, message: "Please enter a complete street address" },
            on: :update

  validates :customer_zipcode,
            presence: { message: "Please enter a zipcode" },
            numericality: { message: "Zipcode must be a 5 digit number" },
            length: { is: 5, message: "Zipcode must be a 5 digit number" },
            on: :update

  validates :credit_card_number,
            presence: { message: "Please enter a credit card number" },
            numericality: { message: "Credit card must be a 16 digit number" },
            length: { is: 16, message: "Credit card must be a 16 digit number" },
            on: :update

   validates_presence_of :customer_city,
                         message: "Please enter a city",
                         on: :update

   validates_presence_of :customer_state,
                         on: :update,
                         message: "Please enter a state"
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
