class RenameCategoryProductsTableToCategoriesProducts < ActiveRecord::Migration[5.0]
  def change
    rename_table :category_products, :categories_products

  end
end
