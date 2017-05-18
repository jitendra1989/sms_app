class CreateMgGroupedExams < ActiveRecord::Migration
  def change
    create_table :mg_grouped_exams do |t|
      t.integer :mg_exam_group_id
      t.integer :mg_batch_id
      t.float :weightage

      
      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
