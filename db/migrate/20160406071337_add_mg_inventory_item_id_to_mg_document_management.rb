class AddMgInventoryItemIdToMgDocumentManagement < ActiveRecord::Migration
  def change
    add_column :mg_document_managements, :mg_inventory_item_id, :integer
  end
end
