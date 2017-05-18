class AddUserTypeToMgResourceInventory < ActiveRecord::Migration
  def change
    add_column :mg_resource_inventories, :user_type, :string
  end
end
