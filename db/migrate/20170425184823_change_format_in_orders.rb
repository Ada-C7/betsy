class ChangeFormatInOrders < ActiveRecord::Migration[5.0]
  def change
    change_column :orders, :card_expiration, :date
  end
end
