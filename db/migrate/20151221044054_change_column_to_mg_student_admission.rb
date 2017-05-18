class ChangeColumnToMgStudentAdmission < ActiveRecord::Migration
  def change
    change_column :mg_student_admissions, :phone_number, :integer, :limit => 8
  end
end
