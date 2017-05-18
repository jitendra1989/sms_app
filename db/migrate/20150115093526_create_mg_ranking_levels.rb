class CreateMgRankingLevels < ActiveRecord::Migration
  def change
    create_table :mg_ranking_levels do |t|
      t.string :name
      t.float :gpa
      t.float :marks
      t.integer :subject_count
      t.integer :priority
      t.integer :full_course
      t.integer :mg_course_id
      t.string :subject_limit_type
      t.string :marks_limit_type

      #Audit fields
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
