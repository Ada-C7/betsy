class AddColsToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :customer_city, :string
    add_column :orders, :customer_zipcode, :string
    add_column :orders, :customer_state, :string
  end
end
