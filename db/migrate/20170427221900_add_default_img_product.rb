class AddDefaultImgProduct < ActiveRecord::Migration[5.0]
  def change
    change_column :products, :image_url, :string, :default => '/assets/ghost_placeholder.jpg'
  end
end
