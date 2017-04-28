class RenameCategoryProductTableToBePlural < ActiveRecord::Migration[5.0]
  def change
    rename_table :category_product, :categories_products
  end
end
