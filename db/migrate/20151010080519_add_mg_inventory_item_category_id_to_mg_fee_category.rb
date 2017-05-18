class AddMgInventoryItemCategoryIdToMgFeeCategory < ActiveRecord::Migration
  def change
    add_column :mg_fee_categories, :mg_inventory_item_category_id, :integer
    add_column :mg_fee_categories, :mg_inventory_item_id, :integer

  end
end
