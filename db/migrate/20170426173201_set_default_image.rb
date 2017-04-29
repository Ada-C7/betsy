class SetDefaultImage < ActiveRecord::Migration[5.0]
  def change
    change_column_default(:products, :photo_url, "http://www.rawdogplus.com/wp-content/uploads/2015/05/pic-coming-soon_150x150.jpg")
  end
end
