class AddColumnInMgInventoryItemConsumption < ActiveRecord::Migration
  def change
  	 add_column :mg_inventory_item_consumptions, :mg_student_id, :integer
  	 add_column :mg_inventory_item_consumptions, :mg_employee_id, :integer
  end
end
