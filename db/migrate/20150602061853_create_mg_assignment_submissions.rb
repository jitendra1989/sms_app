class CreateMgAssignmentSubmissions < ActiveRecord::Migration
  def change
    create_table :mg_assignment_submissions do |t|
      t.integer :mg_student_id
      t.integer :mg_assignment_id
      t.string :status
      t.text :remarks
      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
