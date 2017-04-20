class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.belongs_to :merchant
      t.string :category
      t.string :name
      t.decimal :price
      t.string :description
      t.string :image

      t.integer :inventory
      t.string :status

      t.timestamps
    end
  end
end
