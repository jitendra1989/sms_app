class CreateMgEmployeeSubjects < ActiveRecord::Migration
  def change
    create_table :mg_employee_subjects do |t|

      t.integer :mg_employee_id
      t.integer :mg_subject_id
      
      #Audit fields
      t.integer :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
