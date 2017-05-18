class AddSelectionIndexToMgStudentAdmission < ActiveRecord::Migration
  def change
    add_column :mg_student_admissions, :selection_index, :float    
    add_column :mg_student_admissions, :exam_total_marks, :integer
    add_column :mg_student_admissions, :obtained_marks, :float   
    add_column :mg_student_admissions, :student_temporary_id, :integer   
    add_column :mg_student_admissions, :previous_education_weightage, :float   
    add_column :mg_student_admissions, :entrance_exam_weightage, :float   
  end
end


