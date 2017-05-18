class CreateMgInventoryItemDamageds < ActiveRecord::Migration
  def change
    create_table :mg_inventory_item_damageds do |t|
      t.integer :mg_inventory_item_consumption_id
      t.date :return_date
      t.integer :mg_employee_id
      t.integer :mg_student_id
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by
      t.boolean :is_deleted


      t.timestamps
    end
  end
end
