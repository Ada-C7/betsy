class Merchant < ApplicationRecord
  has_many :products
  has_many :orders, through: :products
  validates :merchant_email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :oauth_uid, presence: true
  validates :oauth_provider, presence: true

  def self.from_github(auth_hash)
    if auth_hash["info"]["email"].nil?
      auth_hash["info"]["email"] = auth_hash["info"]["merchant_email"]
    end

    merchant = Merchant.new(
    username: auth_hash["info"]["nickname"],
    merchant_name: auth_hash["info"]["name"],
    merchant_email: auth_hash["info"]["email"],
    oauth_uid: auth_hash["uid"],
    oauth_provider: "github"
    )
    return merchant
  end


end
