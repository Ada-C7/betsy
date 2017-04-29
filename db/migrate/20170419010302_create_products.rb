class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :product_name
      t.float :price
      t.belongs_to :merchant
      t.string :photo_url
      t.integer :stock
      t.string :product_description
      t.timestamps
    end
  end
end
