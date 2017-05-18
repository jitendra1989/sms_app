class CreateMgCheckUpScheduleRecords < ActiveRecord::Migration
  def change
    create_table :mg_check_up_schedule_records do |t|
      t.integer :mg_check_up_schedule_id
      t.integer :mg_employee_department_id
      t.integer :mg_batch_id
      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by
      t.timestamps
    end
  end
end
