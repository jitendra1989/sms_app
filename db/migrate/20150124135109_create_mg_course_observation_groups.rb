class CreateMgCourseObservationGroups < ActiveRecord::Migration
  def change
    create_table :mg_course_observation_groups do |t|
      t.integer :mg_observation_group_id
      t.integer :mg_course_id

      
      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
