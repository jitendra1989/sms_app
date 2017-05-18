class AddRenewlCountToMgResourceInventory < ActiveRecord::Migration
  def change
    add_column :mg_resource_inventories, :renewal_count, :integer
  end
end
