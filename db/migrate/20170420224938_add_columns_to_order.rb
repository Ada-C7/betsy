class AddColumnsToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :email, :string
    add_column :orders, :address, :string
    add_column :orders, :name_on_cc, :string
    add_column :orders, :cc_number, :integer
    add_column :orders, :cc_ccv, :integer
    add_column :orders, :billing_zip, :integer
  end
end
