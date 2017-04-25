class AddDefaultUserImage < ActiveRecord::Migration[5.0]
  def change
    change_column_default :users, :image_url, 'default-user-image.png'
  end
end
