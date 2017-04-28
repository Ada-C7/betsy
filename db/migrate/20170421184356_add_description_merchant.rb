class AddDescriptionMerchant < ActiveRecord::Migration[5.0]
  def change
    add_column :merchants, :description, :text
  end
end
