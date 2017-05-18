class AddIsFromCentralToMgInventoryProposals < ActiveRecord::Migration
  def change
  	add_column :mg_inventory_proposals, :is_from_central, :boolean
  end
end
