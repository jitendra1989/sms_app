class CreateMgCourses < ActiveRecord::Migration
  def change
    create_table :mg_courses do |t|
    	t.string :course_name
      t.string :code
      t.string :section_name
      t.string :grading_type
      
      t.integer :mg_wing_id
      
       # Audit Fields
       t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
