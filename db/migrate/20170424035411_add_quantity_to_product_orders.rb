class AddQuantityToProductOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :product_orders, :quantity, :integer
  end
end
