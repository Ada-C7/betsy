class RenameCategoryProductsTable < ActiveRecord::Migration[5.0]
  def change
    rename_table :category_products_joins, :category_products
  end
end
