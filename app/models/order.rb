class Order < ApplicationRecord
  has_many :orderedproducts
  has_many :products, through: :orderedproducts


  #inclusion forces presence to be true!!!!!
  validates :status, inclusion: {
    in: [ "pending", "paid", "shipped", "cancelled" ]
  }

  validates :email, presence: true, on: :update
  validates :mailing_address, presence: true, format: {with: /\A[a-zA-Z0-9 ]+\z/}, on: :update
  validates :name_on_cc, presence: true, format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters"}, on: :update
  validates :cc_num, presence: true, numericality: { only_integer: true }, length: { is: 4 }, on: :update
  validates :cc_exp, presence: true, numericality: { only_integer: true }, length: { is: 4 }, on: :update
  validates :cc_csv, presence: true, numericality: { only_integer: true }, length: { in: 3..4 }, on: :update
  validates :zip_code, presence: true, numericality: { only_integer: true }, length: { is: 5 }, on: :update

  def item_total
    orderedproducts.map { |op| op.quantity }.sum
  end

  def verify_inventory
    unavailable = []
    orderedproducts.each do |op|
      unavailable << op.product.name if (op.quantity > op.product.inventory)
    end
    return unavailable
  end

  def modify_inventory(operator)
    unless operator == "-" || operator == "+"
      raise ArgumentError.new("Can only increase or decrease inventory")
    end

    orderedproducts.each do |op|
      op.product.inventory -= op.quantity if operator == "-"
      op.product.inventory += op.quantity if operator == "+"
      op.product.save
    end
  end

  def total
    t = 0
    orderedproducts.each do |op|
      t += (op.product.price * op.quantity)
    end
    return t.round(2)
  end



    # def self.paid_for_merchant(merchant_id)
    #   paid_orders = Order.where(status: "paid")
    #   paid_orders.map { |order| order.products }
    # end

    # def self.for_merchant(merchant_id, status)
    #   orders = Order.where(status: "paid")
    #   orders.each do |order|
    #     order.products.each do |product|
    #       orders.delete(order) if product.merchant_id != merchant_id
    #     end
    #   end
    # end

end
