class AddMerchantColumnToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :merchant_id, :integer
  end
end
