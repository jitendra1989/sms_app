class AddMgLaboratorySubjectIdAndMgLaboratoryRoomIdToMgFeeFineParticular < ActiveRecord::Migration
  def change
    add_column :mg_fee_fine_particulars, :mg_laboratory_subject_id, :integer
    add_column :mg_fee_fine_particulars, :mg_laboratory_room_id, :integer
  end
end
