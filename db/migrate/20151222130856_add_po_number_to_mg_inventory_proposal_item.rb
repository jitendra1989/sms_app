class AddPoNumberToMgInventoryProposalItem < ActiveRecord::Migration
  def change
    add_column :mg_inventory_proposal_items, :po_number, :string
  end
end
