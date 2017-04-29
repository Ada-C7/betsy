class AddColumnsToControllers < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :cvv, :integer
    add_column :orderproducts, :status, :string
    add_column :products, :original_stock, :integer
    change_column :orders, :cc_num, :string
  end
end
