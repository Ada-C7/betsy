class AddUserProfile < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :profile, :text, default: "This user has no profile yet."
  end
end
