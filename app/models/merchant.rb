class Merchant < ApplicationRecord
  has_many :products

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  def self.create_from_github(auth_hash)
    merchant = Merchant.new
    merchant.uid = auth_hash['uid']
    merchant.provider = auth_hash['provider']
    merchant.username = auth_hash['info']['nickname']
    merchant.email = auth_hash['info']['email']
    merchant.save ? merchant : nil # if it's saved, it will return the user. Otherwise, it returns nil. w/o this, it will return true or false
  end

  # def orders
    # @orders = Order.where()
    # We want all the Orders of a specific Merchant
    # Order.orderitems gives you the Orderitems of a specific Order
    # Product.orderitems gives you the Orderitems of a specific Product
    # Order.products.orderitems gives you the Orderitems of all the products that belong to an order
    #
    # Orderitem
    # belongs_to :order
    # belongs_to :product, :foreign_key => 'product_id'
    #
    # Order
    # has_many :orderitems #,:dependent => :destroy
    #
    # Product
    # belongs_to :merchant, :foreign_key => 'merchant_id'
    # has_many :orderitems
  # end
end
