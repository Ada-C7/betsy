class AddsRelationships < ActiveRecord::Migration[5.0]
  def change
    add_reference :products, :user, foreign_key: true
    add_reference :reviews, :product, foreign_key: true
    add_reference :order_items, :product, foreign_key: true
    add_reference :order_items, :order, foreign_key: true
    add_reference :orders, :user, foreign_key: true
  end
end
