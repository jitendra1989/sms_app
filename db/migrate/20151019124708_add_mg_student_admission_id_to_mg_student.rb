class AddMgStudentAdmissionIdToMgStudent < ActiveRecord::Migration
  def change
    add_column :mg_students, :mg_student_admission_id, :integer    
  end
end
