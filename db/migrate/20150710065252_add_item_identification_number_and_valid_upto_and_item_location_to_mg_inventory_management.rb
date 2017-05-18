class AddItemIdentificationNumberAndValidUptoAndItemLocationToMgInventoryManagement < ActiveRecord::Migration
  def change
    add_column :mg_inventory_managements, :item_identification_number, :string
    add_column :mg_inventory_managements, :valid_upto, :date
    add_column :mg_inventory_managements, :item_location, :string
  end
end
