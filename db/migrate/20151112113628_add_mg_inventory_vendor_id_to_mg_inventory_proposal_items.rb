class AddMgInventoryVendorIdToMgInventoryProposalItems < ActiveRecord::Migration
  def change
    add_column :mg_inventory_proposal_items, :mg_inventory_vendor_id, :integer
  end
end
