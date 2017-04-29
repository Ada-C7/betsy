class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.integer :stock
      t.string :name
      t.float :price
      t.integer :user_id
      t.string :photo
      t.boolean :status

      t.timestamps
    end
  end
end
