class AddMgItemUnitIdToMgInventoryItem < ActiveRecord::Migration
  def change
    add_column :mg_inventory_items, :mg_item_unit_id, :integer
  end
end
