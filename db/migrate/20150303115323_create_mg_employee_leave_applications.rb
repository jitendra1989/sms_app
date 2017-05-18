class CreateMgEmployeeLeaveApplications < ActiveRecord::Migration
  def change
    create_table :mg_employee_leave_applications do |t|
      t.integer :mg_employee_id
      t.integer :mg_employee_leave_type_id
      t.date :from_date
      t.date :to_date
      t.string :reject_reason
      t.string :reason
      t.string :status
      t.boolean :is_halfday
      t.boolean :is_afternoon
      t.date :status_date
      t.date :applied_date
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
