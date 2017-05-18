class AddMgHostelDetailsIdToMgHostelRoomType < ActiveRecord::Migration
  def change
    add_column :mg_hostel_room_types, :mg_hostel_details_id, :integer
  end
end
