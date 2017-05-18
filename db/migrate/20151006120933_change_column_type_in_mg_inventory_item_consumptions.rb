class ChangeColumnTypeInMgInventoryItemConsumptions < ActiveRecord::Migration
  def change
  	change_column :mg_inventory_item_consumptions,:description,:text
  end
end
