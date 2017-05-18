class AddIssuedToToMgResourceInventory < ActiveRecord::Migration
  def change
    add_column :mg_resource_inventories, :issued_to, :integer
    add_column :mg_resource_inventories, :due_date, :date
    add_column :mg_resource_inventories, :issued_date, :date

  end
end
