class CreateMerchants < ActiveRecord::Migration[5.0]
  def change
    create_table :merchants do |t|
      t.string :name
      t.string :username
      t.string :email

      t.timestamps
    end
  end
end
