class AddQuantityAvalableToMgInventoryItemManagements < ActiveRecord::Migration
  def change
    add_column :mg_inventory_item_managements, :quantity_available, :integer
  end
end
