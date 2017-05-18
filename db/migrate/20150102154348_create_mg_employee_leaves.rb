class CreateMgEmployeeLeaves < ActiveRecord::Migration
  def change
    create_table :mg_employee_leaves do |t|

      t.integer :mg_employee_id
      t.integer :mg_leave_type_id
      t.integer :leave_taken
      
      #Audit fields
      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
