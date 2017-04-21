class CreateProductorders < ActiveRecord::Migration[5.0]
  def change
    create_table :productorders do |t|
      t.belongs_to :products
      t.belongs_to :orders

      t.timestamps
    end
  end
end
