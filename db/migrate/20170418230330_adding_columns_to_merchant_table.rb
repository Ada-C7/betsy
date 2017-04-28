class AddingColumnsToMerchantTable < ActiveRecord::Migration[5.0]
  def change
    add_column :merchants, :email, :string
    add_column :merchants, :username, :string
  end
end
