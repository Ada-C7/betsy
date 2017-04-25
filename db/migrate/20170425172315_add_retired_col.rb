class AddRetiredCol < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :retired, :boolean, default: "false"
  end
end
