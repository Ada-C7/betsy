class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.string :status
      t.string :email
      t.string :billing_name
      t.text :address
      t.string :card_number
      t.date :card_expiration
      t.string :cvv
      t.string :zipcode

      t.timestamps
    end
  end
end
