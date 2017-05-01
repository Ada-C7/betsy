class UpdateMerchantModelForGithub < ActiveRecord::Migration[5.0]
  def change
    add_column :merchants, :oauth_uid, :string
    add_column :merchants, :oauth_provider, :string
  end
end
