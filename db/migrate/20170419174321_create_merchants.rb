class CreateMerchants < ActiveRecord::Migration[5.0]
  def change
    create_table :merchants do |t|
      t.string :username
      t.string :oauth_id
      t.string :oauth_provider
      t.string :email

      t.timestamps
    end
  end
end
