class QuanityColumnToProductorder < ActiveRecord::Migration[5.0]
  def change
    add_column :productorders, :quantity, :integer
  end
end
