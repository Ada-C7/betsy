class AddColumnToCategories < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :photo, :string, default: "http://www.clipartkid.com/images/211/for-money-sign-images-displaying-19-images-for-money-sign-images-TrIQ7p-clipart.jpg"
  end
end
