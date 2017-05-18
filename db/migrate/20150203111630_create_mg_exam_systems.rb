class CreateMgExamSystems < ActiveRecord::Migration
  def change
    create_table :mg_exam_systems do |t|
      # not sure for this column
      t.string :grading_name

      t.integer :grading_system
      t.text :description
      t.integer :is_enabled
      
      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
