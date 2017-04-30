class Merchant < ApplicationRecord
  validates :username, presence: true, uniqueness: true
  # validates :email, presence: true, message: "Provider was not able to retrieve an email. Email is required for login"
  # validates :oauth_uid, presence: true
  # validates :oauth_provider, presence: true
  has_many :products

  def self.from_github(auth_hash)
    merchant = Merchant.new
    merchant.username = auth_hash["info"]["nickname"]
    merchant.email = auth_hash["info"]["email"]
    merchant.oauth_uid = auth_hash["uid"]
    merchant.oauth_provider = "github"
    return merchant
  end

end
