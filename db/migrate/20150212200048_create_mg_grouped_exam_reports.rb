class CreateMgGroupedExamReports < ActiveRecord::Migration
  def change
    create_table :mg_grouped_exam_reports do |t|
      t.integer :mg_batch_id
      t.integer :mg_student_id
      t.integer :mg_exam_group_id
      t.float :marks
      t.string :score_type
      t.integer :mg_subject_id
      t.integer :mg_school_id
      t.integer :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
