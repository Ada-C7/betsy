class DropDefaultReviewNamef < ActiveRecord::Migration[5.0]
  def change
    change_column_default :reviews, :nickname, nil 
  end
end
