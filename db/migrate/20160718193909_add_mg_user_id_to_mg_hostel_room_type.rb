class AddMgUserIdToMgHostelRoomType < ActiveRecord::Migration
  def change
    add_column :mg_hostel_room_types, :mg_user_id, :integer
  end
end
