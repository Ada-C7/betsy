class Payment < ApplicationRecord

  validates :name_on_card, presence: true
  validates :name_on_card, presence: true
  validates :email, presence: true
  validates :phone_num, presence: true
  validates :ship_address, presence: true
  validates :bill_address, presence: true
  validates :card_number, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates_length_of :card_number, :minimum => 16, :maximum => 19
  validates :expiration_date, presence: true
  validates :CCV, presence: true
  validates_length_of :CCV, :minimum => 3, :maximum => 4

  def paid
  end
end
