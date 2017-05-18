class AddOnlineDetailsToMgInventoryItem < ActiveRecord::Migration
  def change
    add_column :mg_inventory_items, :available_online, :boolean
    add_column :mg_inventory_items, :reserved_for_offline, :integer, :limit=>8
    add_column :mg_inventory_items, :online_price, :integer
  end
end
