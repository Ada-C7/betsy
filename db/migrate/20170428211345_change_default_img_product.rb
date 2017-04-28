class ChangeDefaultImgProduct < ActiveRecord::Migration[5.0]
  def change
    change_column :products, :image_url, :string, :default => 'http://img13.deviantart.net/1568/i/2015/280/7/b/donut_ghost_by_doctorhue2-d9cbpmk.png'
  end
end
