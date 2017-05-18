class AddDateOfReqirementToMgInventoryProposal < ActiveRecord::Migration
  def change
    add_column :mg_inventory_proposals, :date, :date
  end
end
