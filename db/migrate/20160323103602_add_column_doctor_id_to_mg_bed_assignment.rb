class AddColumnDoctorIdToMgBedAssignment < ActiveRecord::Migration
  def change
    add_column :mg_bed_assignments, :mg_doctor_id, :integer
    add_column :mg_bed_assignments, :comments, :text
  end
end
