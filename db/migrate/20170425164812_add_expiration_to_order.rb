class AddExpirationToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :card_expiration, :datetime
  end
end
