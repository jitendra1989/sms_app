class CreateMgEmployeeAttendances < ActiveRecord::Migration
  def change
    create_table :mg_employee_attendances do |t|

    	t.date    :absent_date
    	t.integer :mg_employee_id
        t.integer :mg_leave_type_id
        t.integer :is_approved
    	t.boolean :is_lock

        t.string  :reason
    	t.string  :time

        t.boolean :is_halfday
    	t.boolean :is_late_come
        t.boolean :is_afternoon
    	t.boolean :abcent_without_notice
        t.integer :mg_employee_department_id

    	#Audit fields
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by
      t.timestamps
    end
  end
end
