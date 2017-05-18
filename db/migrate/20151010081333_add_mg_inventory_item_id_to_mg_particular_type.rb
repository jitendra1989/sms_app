class AddMgInventoryItemIdToMgParticularType < ActiveRecord::Migration
  def change
    add_column :mg_particular_types, :mg_inventory_item_id, :integer
  end
end
