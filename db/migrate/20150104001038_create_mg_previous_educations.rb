class CreateMgPreviousEducations < ActiveRecord::Migration
  def change
    create_table :mg_previous_educations do |t|

      t.string :school_name
      t.string :course
      t.string :grade
      # check is their
      t.integer :year
      t.integer :mg_student_id
      t.integer :marks_obtained

      t.decimal :total_marks

      #Audit fields
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
