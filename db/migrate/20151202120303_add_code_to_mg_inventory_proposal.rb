class AddCodeToMgInventoryProposal < ActiveRecord::Migration
  def change
    add_column :mg_inventory_proposals, :code, :string
  end
end
