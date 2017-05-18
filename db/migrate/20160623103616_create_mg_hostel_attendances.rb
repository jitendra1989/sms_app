class CreateMgHostelAttendances < ActiveRecord::Migration
  def change
    create_table :mg_hostel_attendances do |t|

      t.date    :absent_date
      t.integer :mg_student_id
      t.integer :mg_wing_id
      # t.integer :mg_leave_type_id
      t.integer :is_approved
      t.boolean :is_lock
      t.text  :reason
      t.text  :morning_reason 
      t.text  :evening_reason 
      t.text  :morning_late_reason
      t.text  :evening_late_reason
      t.string  :time
      t.string  :evening_late_time
      # t.boolean :is_halfday
      t.boolean :is_late_come
      t.boolean :is_evening_late_come
      # t.boolean :is_afternoon
      t.boolean :absent_without_notice
      # t.integer :mg_employee_department_id
      t.integer :mg_hostel_detail_id
      t.boolean :is_morning
      t.boolean :is_evening
      
      #Audit fields
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end

