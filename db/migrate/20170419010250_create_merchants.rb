class CreateMerchants < ActiveRecord::Migration[5.0]
  def change
    create_table :merchants do |t|
      t.string :merchant_name
      t.string :merchant_email
      t.string :username
      t.timestamps
    end
  end
end
