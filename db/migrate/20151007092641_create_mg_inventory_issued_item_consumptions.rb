class CreateMgInventoryIssuedItemConsumptions < ActiveRecord::Migration
  def change
    create_table :mg_inventory_issued_item_consumptions do |t|
      t.integer :mg_inventory_item_consumption_id
      t.string :mg_consumer_type
      t.integer :mg_batch_id
      t.integer :mg_student_id
      t.integer :mg_department_id
      t.integer :mg_employee_id
      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
