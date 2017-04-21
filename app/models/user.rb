class User < ApplicationRecord
  has_many :products
  has_many :orders

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
end
