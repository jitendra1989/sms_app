class AddMgStudentAdmissionIdToMgUser < ActiveRecord::Migration
  def change
    add_column :mg_users, :mg_student_admission_id, :integer  
  end
end
