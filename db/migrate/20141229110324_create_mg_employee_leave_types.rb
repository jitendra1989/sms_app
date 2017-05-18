class CreateMgEmployeeLeaveTypes < ActiveRecord::Migration
  def change
    create_table :mg_employee_leave_types do |t|
    	t.string :leave_name
      t.string :leave_code
      t.integer :max_leave_count
      t.integer :reset_period
      t.date :reset_date
      t.boolean :is_auto_reset
      t.boolean :is_carry_forward
      t.boolean :status


      t.string :carry_forward_limit
      t.string :accumilation_count
      t.string :accumilation_period
      t.string :min_leave_count
      t.integer :mg_employee_type_id

      #Audit fields
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by


      t.timestamps
    end
  end
end
