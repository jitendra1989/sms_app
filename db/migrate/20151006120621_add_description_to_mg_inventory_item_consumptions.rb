class AddDescriptionToMgInventoryItemConsumptions < ActiveRecord::Migration
  def change
    add_column :mg_inventory_item_consumptions, :description, :string
  end
end
