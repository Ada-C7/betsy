class ChangeLimitOnCreditCardNumberOrder < ActiveRecord::Migration[5.0]
  def change
    change_column :orders, :cc_number, :bigint
  end
end
