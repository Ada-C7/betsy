class RemoveColumnShippedOrderItem < ActiveRecord::Migration[5.0]
  def change
      remove_column :order_items, :shipped, :boolean
  end
end
