class AddColumnMgEntranceExamDetailsIdToMgStudentAdmission < ActiveRecord::Migration
  def change
    add_column :mg_student_admissions, :mg_entrance_exam_details_id, :integer
  end
end
