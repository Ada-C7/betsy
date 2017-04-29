class AddColumnToOrder < ActiveRecord::Migration[5.0]
    def change
        add_column :orders, :email_address, :string
        add_column :orders, :mailing_address, :string
        add_column :orders, :card_name, :string
        add_column :orders, :card_expiration, :date
        add_column :orders, :card_cvv, :integer
        add_column :orders, :zipcode, :integer
    end
end
