class AddVisibletoStudentToMgHostelDetails < ActiveRecord::Migration
  def change
    add_column :mg_hostel_details, :visible_to_student, :boolean
  end
end
