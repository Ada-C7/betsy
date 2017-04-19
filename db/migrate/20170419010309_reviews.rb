class Reviews < ActiveRecord::Migration[5.0]
  def change
    create_table :reviews do |t|
      t.belongs_to :product
      t.integer :rating
      t.string :review_description
    end
  end
end
