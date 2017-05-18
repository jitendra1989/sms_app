class CreateMgInventoryStoreManagers < ActiveRecord::Migration
  def change
    create_table :mg_inventory_store_managers do |t|
      t.integer :mg_inventory_store_management_id
      t.integer :mg_employee_department_id
      t.integer :mg_employee_id
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
