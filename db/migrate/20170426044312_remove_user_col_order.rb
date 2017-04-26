class RemoveUserColOrder < ActiveRecord::Migration[5.0]
  def change
    remove_column(:orders, :user_id)
  end
end
