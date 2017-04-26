class Order < ApplicationRecord
  has_many :orderedproducts
  has_many :products, through: :orderedproducts

  #inclusion forces presence to be true!!!!!
  validates :status, inclusion: {
    in: [ "pending", "paid", "shipped", "cancelled" ]
  }

  # do this later
  # validates :email,
  # validates :mailing_address,
  # validates :name_on_cc,
  # validates :cc_num,
  # validates :cc_exp,
  # validates :cc_csv,
  # validates :zip_code,

  def total
    t = 0
    orderedproducts.each do |op|
      t += (op.product.price * op.quantity)
    end
    return t.round(2)
  end

end
