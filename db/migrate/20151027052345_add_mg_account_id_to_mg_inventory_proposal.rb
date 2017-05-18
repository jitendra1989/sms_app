class AddMgAccountIdToMgInventoryProposal < ActiveRecord::Migration
  def change
    add_column :mg_inventory_proposals, :mg_account_id, :integer
    add_column :mg_inventory_proposals, :amount, :integer
  end
end
