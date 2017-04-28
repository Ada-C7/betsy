class CreateProductCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :product_categories do |t|
      t.belongs_to :product
      t.belongs_to :category

      t.timestamps
    end
  end
end
