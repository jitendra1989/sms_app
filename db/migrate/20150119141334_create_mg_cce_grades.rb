class CreateMgCceGrades < ActiveRecord::Migration
  def change
    create_table :mg_cce_grades do |t|
      t.string :name
      t.float :grade_point
      t.integer :mg_cce_grades_set_id
      
      #audit field
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
