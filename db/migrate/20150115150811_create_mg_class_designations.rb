class CreateMgClassDesignations < ActiveRecord::Migration
  def change
    create_table :mg_class_designations do |t|
      t.string :name
      t.float :marks
      t.integer :mg_course_id
      t.float :cgpa

      #Audit fields
      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
