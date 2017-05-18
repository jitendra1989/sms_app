class AddUnitPriceToMgInventoryVendorItem < ActiveRecord::Migration
  def change
    add_column :mg_inventory_vendor_items, :unit_price, :integer
  end
end
