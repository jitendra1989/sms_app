class AddMgLaboratoryItemIdAndPrefixToMgLabInventory < ActiveRecord::Migration
  def change
    add_column :mg_lab_inventories, :mg_laboratory_item_id, :integer
    add_column :mg_lab_inventories, :prefix, :string
  end
end
