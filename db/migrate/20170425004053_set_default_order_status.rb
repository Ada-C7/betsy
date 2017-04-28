class SetDefaultOrderStatus < ActiveRecord::Migration[5.0]
  def change
    change_column_default :orders, :status, from: nil, to: 'pending'
  end
end
