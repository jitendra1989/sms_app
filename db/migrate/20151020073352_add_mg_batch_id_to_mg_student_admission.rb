class AddMgBatchIdToMgStudentAdmission < ActiveRecord::Migration
  def change
    add_column :mg_student_admissions, :mg_batch_id, :integer  
    add_column :mg_student_admissions, :mg_student_category_id, :integer  
  end
end


