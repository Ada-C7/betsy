class CreateOrdersStatusColumn < ActiveRecord::Migration[5.0]
  def change
      add_column :orders, :status, :string, default: "pending"
  end
end
