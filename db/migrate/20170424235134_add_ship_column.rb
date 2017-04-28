class AddShipColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :order_items, :ship_status, :boolean, default: false
  end
end
