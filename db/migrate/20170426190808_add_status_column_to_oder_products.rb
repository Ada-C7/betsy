class AddStatusColumnToOderProducts < ActiveRecord::Migration[5.0]
  def change
      add_column :order_products, :status, :string, :default => "not shipped"
  end

end
