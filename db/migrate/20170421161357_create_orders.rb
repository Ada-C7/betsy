class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.string :customer_name
      t.string :customer_address
      t.string :customer_email
      t.string :customer_cc_info
      t.string :status

      t.timestamps
    end
  end
end
