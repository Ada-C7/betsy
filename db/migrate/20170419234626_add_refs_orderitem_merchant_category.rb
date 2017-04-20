class AddRefsOrderitemMerchantCategory < ActiveRecord::Migration[5.0]
  def change
    add_reference :orderitems, :order, foreign_key: true
    add_reference :orderitems, :product, foreign_key: true
  end
end
