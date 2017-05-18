class AddDateOfExpiryToMgInventoryItemManagement < ActiveRecord::Migration
  def change
    add_column :mg_inventory_item_managements, :date_of_expiry, :date
  end
end
