class Order < ApplicationRecord
  validates :status, presence: true, inclusion: { in: %w(pending paid complete cancelled), message: "%{value} is not a valid status."}
  has_many :products, through: :orderproducts
  has_many :orderproducts
  has_many :merchants, through: :products
  validates :cc_name, presence: true
  validates :cc_num, presence: true, format: { with: /[0-9]/, message: "please enter numbers only"}
  validates :order_email, presence: true
  validates :mailing_address, presence: true
  validates :cc_expiry, presence: true
  validates :cvv, presence: true,length: { is: 3 }, numericality: { only_integer: true, greater_than: 0, message: "Please enter cvv number must be 3 digits" }

  def subtotal
    quantities = self.orderproducts.map{|orderproduct| orderproduct[:quantity]}

    @subtotal = 0
    @prices = []
    self.orderproducts.each do |orderproduct|
      @prices << Product.find_by(id: orderproduct.product_id).price
    end
    @prices.zip(quantities).each do |price, quantity|
      @subtotal += price * quantity
    end
    return @subtotal
  end

  def tax
    subtotal * 0.095
  end

  def total
    subtotal + tax + 5
  end

end
