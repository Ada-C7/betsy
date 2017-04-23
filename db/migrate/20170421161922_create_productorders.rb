class CreateProductorders < ActiveRecord::Migration[5.0]
  def change
    create_table :productorders do |t|
      t.belongs_to :product
      t.belongs_to :order
      t.timestamps
    end
  end
end
