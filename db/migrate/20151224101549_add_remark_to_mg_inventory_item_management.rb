class AddRemarkToMgInventoryItemManagement < ActiveRecord::Migration
  def change
    add_column :mg_inventory_item_managements, :remark, :string
  end
end
