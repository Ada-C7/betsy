class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  # Commentibng out to help our testing %
  # def self.to_csv
  #   attributes = %w(id order_id product_id quantity )
  #   CSV.generate( headers: true ) do |csv|
  #     csv << attributes
  #
  #     all.each do |order_item|
  #       csv << order_item.attributes.values_at(*attributes)
  #     end
  #   end
  # end

  def subtotal
    if product
      subtotal = product.price * quantity
      return subtotal.round(2)
    else
      return nil
    end
  end
end
