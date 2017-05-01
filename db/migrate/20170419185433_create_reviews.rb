class CreateReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :reviews do |t|
      t.integer :rating
      t.string :comment
      t.string :name
      t.integer :product_id

      t.timestamps
    end
  end
end
