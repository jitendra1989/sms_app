class AddMgInventoryStoreManagementIdToInventoryStackManagement < ActiveRecord::Migration
  def change
    add_column :inventory_stack_managements, :mg_inventory_store_management_id, :integer
    add_column :inventory_stack_managements, :mg_inventory_room_management_id, :integer
    
  end
end
