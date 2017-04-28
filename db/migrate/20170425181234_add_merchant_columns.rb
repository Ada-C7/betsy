class AddMerchantColumns < ActiveRecord::Migration[5.0]
  def change
    add_column :merchants, :name, :string
    add_column :merchants, :uid, :integer, null: false
    add_column :merchants, :provider, :string, null: false
  end
end
