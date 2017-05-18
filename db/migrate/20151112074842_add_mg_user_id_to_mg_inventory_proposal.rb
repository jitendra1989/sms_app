class AddMgUserIdToMgInventoryProposal < ActiveRecord::Migration
  def change
  	add_column :mg_inventory_proposals, :mg_user_id, :integer
  end
end
