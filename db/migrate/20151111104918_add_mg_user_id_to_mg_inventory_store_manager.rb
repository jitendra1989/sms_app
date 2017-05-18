class AddMgUserIdToMgInventoryStoreManager < ActiveRecord::Migration
  def change
  	add_column :mg_inventory_store_managers, :mg_user_id, :integer
  end
end
