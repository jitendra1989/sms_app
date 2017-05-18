class AddStatusAndRemarkToMgInventoryProposals < ActiveRecord::Migration
  def change
    add_column :mg_inventory_proposals, :status, :string
    add_column :mg_inventory_proposals, :remark, :text
  end
end
