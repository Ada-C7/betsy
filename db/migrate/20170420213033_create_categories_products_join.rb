class CreateCategoriesProductsJoin < ActiveRecord::Migration[5.0]
  def change
    create_join_table :categories, :products do |t|
      t.belongs_to :category
      t.belongs_to :product
    end
  end
end
