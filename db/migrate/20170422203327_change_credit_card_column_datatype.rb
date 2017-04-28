class ChangeCreditCardColumnDatatype < ActiveRecord::Migration[5.0]
  def change
    change_column :orders, :credit_card, :string
  end
end
