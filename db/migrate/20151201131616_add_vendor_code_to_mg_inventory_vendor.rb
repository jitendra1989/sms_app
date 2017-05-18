class AddVendorCodeToMgInventoryVendor < ActiveRecord::Migration
  def change
    add_column :mg_inventory_vendors, :vendor_code, :string
  end
end
