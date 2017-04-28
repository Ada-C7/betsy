class AddNewColumnsToOrderTable < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :email, :string
    add_column :orders, :address, :string
    add_column :orders, :cc_name, :string
    add_column :orders, :cc_num, :integer
    add_column :orders, :cc_expiry, :string
    add_column :orders, :cc_security, :integer
    add_column :orders, :zip, :integer
  end
end
