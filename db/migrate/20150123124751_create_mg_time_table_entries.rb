class CreateMgTimeTableEntries < ActiveRecord::Migration
  def change
    create_table :mg_time_table_entries do |t|
      t.integer :mg_batch_id
      t.integer :mg_weekday_id
      t.integer :mg_class_timings_id
      t.integer :mg_subject_id
      t.integer :mg_employee_id
      t.integer :mg_timetable_id

      
      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
