class AddNicknameToReviewsTable < ActiveRecord::Migration[5.0]
  def change
    add_column :reviews, :nickname, :string, :default => "Anonymous Customer"
  end
end
