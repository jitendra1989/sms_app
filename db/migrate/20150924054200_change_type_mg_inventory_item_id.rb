class ChangeTypeMgInventoryItemId < ActiveRecord::Migration
  def change
  	change_column :mg_inventory_item_managements, :mg_inventory_item_id, :integer
  	remove_column :mg_inventory_item_managements, :integer, :string
  end
end
