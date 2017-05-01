class AddMerchantToProduct < ActiveRecord::Migration[5.0]
  def change
    add_reference :products, :merchant
  end
end
