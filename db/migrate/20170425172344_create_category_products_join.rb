class CreateCategoryProductsJoin < ActiveRecord::Migration[5.0]
  def change
    create_table :category_products_joins do |t|

      t.belongs_to :category, index:true
      t.belongs_to :product, index:true
    end
  end
end
