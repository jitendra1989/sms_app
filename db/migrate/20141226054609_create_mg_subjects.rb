class CreateMgSubjects < ActiveRecord::Migration
  def change
    create_table :mg_subjects do |t|

      # t.integer :mg_batch_id
      t.integer :mg_course_id

      t.string :subject_name

      t.string :subject_code
      
      t.integer :max_weekly_class

      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
