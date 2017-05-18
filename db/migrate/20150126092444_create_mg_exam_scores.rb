class CreateMgExamScores < ActiveRecord::Migration
  def change
    create_table :mg_exam_scores do |t|
      t.integer :mg_student_id
      t.integer :mg_exam_id
      t.integer :marks
      t.integer :mg_grading_level_id
      t.string :remarks
      t.boolean :is_failed

      
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
