class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.string :name
      t.string :status
      t.string :email
      t.string :address
      t.string :cc_name
      t.integer :cc_number
      t.string :cc_expiration
      t.integer :cc_cvv
      t.integer :zip_code

      t.timestamps
    end
  end
end
