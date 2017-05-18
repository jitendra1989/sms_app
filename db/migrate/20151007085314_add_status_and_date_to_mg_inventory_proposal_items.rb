class AddStatusAndDateToMgInventoryProposalItems < ActiveRecord::Migration
  def change
    add_column :mg_inventory_proposal_items, :status, :string
    add_column :mg_inventory_proposal_items, :date, :date
  end
end
