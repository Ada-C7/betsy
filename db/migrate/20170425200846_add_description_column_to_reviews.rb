class AddDescriptionColumnToReviews < ActiveRecord::Migration[5.0]
  def change
    add_column :reviews, :description, :text
  end
end
