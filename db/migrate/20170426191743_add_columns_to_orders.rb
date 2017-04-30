class AddColumnsToOrders < ActiveRecord::Migration[5.0]
  def change
    rename_column :orders, :customer_cc_info, :credit_card_number
    add_column :orders, :credit_card_cvv, :integer
    add_column :orders, :credit_card_zipcode, :integer
    add_column :orders, :credit_card_name, :string
    add_column :orders, :total, :decimal
    add_column :orders, :subtotal, :decimal
    add_column :orders, :tax, :decimal
  end
end
