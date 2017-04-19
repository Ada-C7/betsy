class CreateMerchants < ActiveRecord::Migration[5.0]
  def change
    create_table :merchants do |t|
      t.string :username
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :oauth_uid
      t.string :oauth_provider
      t.timestamps
    end
  end
end
