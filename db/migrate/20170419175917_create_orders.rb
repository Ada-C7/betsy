class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.string :status
      t.string :email
      t.string :mailing_address
      t.string :card_name
      t.integer :credit_card
      t.integer :cvv
      t.integer :zip_code
      t.datetime :paid_at

      t.timestamps
    end
  end
end
