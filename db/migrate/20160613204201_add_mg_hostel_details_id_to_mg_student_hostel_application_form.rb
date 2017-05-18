class AddMgHostelDetailsIdToMgStudentHostelApplicationForm < ActiveRecord::Migration
  def change
    add_column :mg_student_hostel_application_forms, :mg_hostel_details_id, :integer
  end
end
