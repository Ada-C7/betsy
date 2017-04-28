class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price
      t.string :photo_url
      t.text :description
      t.integer :stock
      t.belongs_to :merchant

      t.timestamps
    end
  end
end
