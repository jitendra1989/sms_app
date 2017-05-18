class CreateMgAssessmentScores < ActiveRecord::Migration
  def change
    create_table :mg_assessment_scores do |t|
      t.integer :mg_student_id
      t.float :grade_points
      t.integer :mg_exam_id
      t.integer :mg_batch_id
      t.integer :mg_descriptive_indicator_id

      
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by
      t.boolean :is_deleted

      t.timestamps
    end
  end
end
