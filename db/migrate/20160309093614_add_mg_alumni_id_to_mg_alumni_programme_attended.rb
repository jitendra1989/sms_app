class AddMgAlumniIdToMgAlumniProgrammeAttended < ActiveRecord::Migration
  def change
    add_column :mg_alumni_programme_attendeds, :mg_alumni_id, :integer
  end
end
