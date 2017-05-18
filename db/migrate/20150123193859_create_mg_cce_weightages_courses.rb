class CreateMgCceWeightagesCourses < ActiveRecord::Migration
  def change
    create_table :mg_cce_weightages_courses do |t|
      t.integer :mg_cce_weightages_id
      t.integer :mg_course_id

      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
