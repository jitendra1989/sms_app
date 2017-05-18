class AddMgUserIdToMgInventoryProjection < ActiveRecord::Migration
  def change
  	add_column :mg_inventory_projections, :mg_user_id, :integer
  end
end
