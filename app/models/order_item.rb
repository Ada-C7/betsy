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

    #how do we get this in the model and still have it be able to talk to the update method
    def check_order_status(id)
        @order = Order.find_by_id(id)

        incomplete = 0
        @order.order_items.each do |item|
            if item.ship_status == false
                incomplete += 1
            end
        end

        if incomplete == 0
            @order.status = 'complete'
            @order.save
        else
            @order.status = 'paid'
            @order.save
        end
        return @order
    end

    def subtotal
        if product
            subtotal = product.price * quantity
            return subtotal.round(2)
        else
            return nil
        end
    end

    def shipping_status
        if self.ship_status
            "Shipped"
        else
            "Not shipped yet"
        end
    end
end
