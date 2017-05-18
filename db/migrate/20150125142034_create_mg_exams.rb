class CreateMgExams < ActiveRecord::Migration
  def change
    create_table :mg_exams do |t|
      t.integer :mg_exam_group_id
      t.integer :mg_subject_id
      t.datetime :start_time
      t.datetime :end_time
      t.float :maximum_marks
      t.float :minimum_marks
      t.integer :mg_grading_level_id
      t.integer :weightage
      t.integer :mg_event_id

      
      t.integer :created_by
      t.integer :updated_by
      t.integer :mg_school_id
      t.boolean :is_deleted

      t.timestamps
    end
  end
end
