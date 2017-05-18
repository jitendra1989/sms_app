class CreateMgStudentAttendances < ActiveRecord::Migration
  def change
    create_table :mg_student_attendances do |t|

      t.integer :mg_student_id
      t.integer :mg_period_table_entry_id
      t.integer :mg_class_timing_id
      t.boolean :is_halfday
      t.boolean :is_afternoon
      t.string :reason
      t.date :absent_date
      t.integer :mg_batch_id
      #Audit fields
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by



      t.timestamps
    end
  end
end
