class AddMgLaboratorySubjectIdToMgLab < ActiveRecord::Migration
  def change
    add_column :mg_labs, :mg_laboratory_subject_id, :integer
  end
end
