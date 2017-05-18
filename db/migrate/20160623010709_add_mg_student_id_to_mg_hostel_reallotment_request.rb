class AddMgStudentIdToMgHostelReallotmentRequest < ActiveRecord::Migration
  def change
    add_column :mg_hostel_reallotment_requests, :mg_student_id, :integer
  end
end
