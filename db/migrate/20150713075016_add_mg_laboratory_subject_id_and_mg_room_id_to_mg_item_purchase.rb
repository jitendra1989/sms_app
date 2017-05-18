class AddMgLaboratorySubjectIdAndMgRoomIdToMgItemPurchase < ActiveRecord::Migration
  def change
    add_column :mg_item_purchases, :mg_laboratory_subject_id, :integer
    add_column :mg_item_purchases, :mg_room_id, :integer
  end
end
