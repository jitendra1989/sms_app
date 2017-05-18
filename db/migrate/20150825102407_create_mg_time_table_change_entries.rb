class CreateMgTimeTableChangeEntries < ActiveRecord::Migration
  def change
    create_table :mg_time_table_change_entries do |t|
      t.integer :mg_time_table_entry_id
      t.integer :mg_batch_id
      t.integer :mg_class_timings_id
      t.integer :mg_timetable_id
      t.integer :mg_subject_id
      t.integer :mg_employee_id
      t.date    :date
      
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by
      t.timestamps
    end
  end
end
