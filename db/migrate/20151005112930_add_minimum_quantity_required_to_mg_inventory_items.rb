class AddMinimumQuantityRequiredToMgInventoryItems < ActiveRecord::Migration
  def change
    add_column :mg_inventory_items, :minimum_quantity_required, :integer
  end
end
