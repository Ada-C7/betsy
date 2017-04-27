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
      product = Product.find_by(id: op.product_id)
      unavailable << product.name if (op.quantity > product.inventory)
    end
    return unavailable
  end


  def total
    t = 0
    orderedproducts.each do |op|
      t += (op.product.price * op.quantity)
    end
    return t.round(2)
  end

end
