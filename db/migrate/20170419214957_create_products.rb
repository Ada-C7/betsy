class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.float :price
      t.string :photo_url
      t.integer :stock
      t.integer :user_id

      t.timestamps
    end
  end
end
