class AddRemarkDescriptionToMgInventoryProposalItems < ActiveRecord::Migration
  def change
    add_column :mg_inventory_proposal_items, :remark_description, :string
  end
end
