class CreateMgInventoryProjections < ActiveRecord::Migration
  def change
    create_table :mg_inventory_projections do |t|
      t.integer :mg_store_id
      t.integer :mg_employee_id
      t.string :requisition_name
      t.text :description
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by
      t.string :status
      t.text :remark

      t.timestamps
    end
  end
end
