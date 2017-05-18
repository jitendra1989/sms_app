class AddMgAlumniProgrammeAttendedIdToMgDocumentManagement < ActiveRecord::Migration
  def change
    add_column :mg_document_managements, :mg_alumni_programme_attended_id, :integer
  end
end
