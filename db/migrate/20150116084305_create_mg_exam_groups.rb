class CreateMgExamGroups < ActiveRecord::Migration
  def change
    create_table :mg_exam_groups do |t|
      t.string :name
      t.integer :mg_batch_id
      t.string :exam_type
      t.integer :is_published
      t.integer :result_published
      t.float :maximum_mark
      t.float :minimum_mark
      t.date :exam_date
      t.integer :is_final_exam
      t.integer :cce_exam_category_id

      #Audit fields
      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
