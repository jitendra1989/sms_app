class AddMgLaboratorySubjectIdAndMgLaboratoryRoomIdToMgInventoryManagement < ActiveRecord::Migration
  def change
    add_column :mg_inventory_managements, :mg_laboratory_subject_id, :integer
    add_column :mg_inventory_managements, :mg_laboratory_room_id, :integer
  end
end
