class CreateReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :reviews do |t|
      t.float :rating
      t.string :comment

      t.timestamps
    end
  end
end
