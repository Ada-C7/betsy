class Order < ApplicationRecord
  has_many :order_products
  validates :status, presence: true, on: :update
  validates :name, presence: true, on: :update
  validates :email, presence: true, on: :update
  validates :address, presence: true, on: :update
  validates :cc_name, presence: true, on: :update
  validates :cc_number, presence: true, on: :update
  validates :cc_expiration, presence: true, on: :update
  validates :cc_cvv, presence: true, on: :update
  validates :zip_code, presence: true, on: :update


  def show_products(id)
    order = Order.find(id)
    @order_products = OrderProduct.where(order_id: id)
    @product_names = @order_products.map{|item| Product.find_by(id: item.product_id)}
  end

  def subtract_inventory(id)
    #after update
    product_quantity = {}
    products = Order.find(id).order_products
    products.each do |product|
      product_quantity[product.id] = product.quantity
    end
    product_quantity.each do |product_id, product_quantity|
      if Product.find(product_id).quantity - product_quantity >= 0
        Product.find(product.product_id).quantity -= product_quantity
      end
    end
  end

  def subtotal
    subtotal_array = []
    #returns an order object
    order = Order.find(id)
    #returns an array of order_products associated with The OrderObject
    @order_products = OrderProduct.where(order_id: id)
    # Returns an array of Products associated with each listed order product
    @product_price = @order_products.map{|item| Product.find_by(id: item.product_id)}
    #iterating through the array of products (called product-price)
    @product_price.each do |price|
        a = price.price
        #here we are scraping the price from each product object and shoveling
        #into the subtotal_array
        subtotal_array << a
      end
    return subtotal_array.inject(:+)
  end


end
