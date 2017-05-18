class AddRejectedByAndReasonToMgStudentHostelApplicationForm < ActiveRecord::Migration
  def change
    add_column :mg_student_hostel_application_forms, :rejected_by, :string
    add_column :mg_student_hostel_application_forms, :reason, :string
  end
end
