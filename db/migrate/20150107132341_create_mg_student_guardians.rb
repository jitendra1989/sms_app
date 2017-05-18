class CreateMgStudentGuardians < ActiveRecord::Migration
  def change
    create_table :mg_student_guardians do |t|
      t.integer :mg_student_id
      t.integer :mg_guardians_id
      t.string :relation
      t.boolean :has_login_access

      #Audit fields
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by
      t.timestamps
    end
  end
end
