class AddMgLaboratorySubjectIdAndMgLaboratoryRoomIdToMgItemConsumption < ActiveRecord::Migration
  def change
    add_column :mg_item_consumptions, :mg_laboratory_subject_id, :integer
    add_column :mg_item_consumptions, :mg_laboratory_room_id, :integer
  end
end
