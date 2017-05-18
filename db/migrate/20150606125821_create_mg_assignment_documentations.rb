class CreateMgAssignmentDocumentations < ActiveRecord::Migration
  def change
    create_table :mg_assignment_documentations do |t|
      t.integer :mg_student_id
      t.integer :mg_assignment_id
      t.integer :mg_employee_id
      t.string :user_type
      t.attachment :file
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
