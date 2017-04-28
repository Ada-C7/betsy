class AddSellingStatusColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :selling_status, :boolean
  end
end
