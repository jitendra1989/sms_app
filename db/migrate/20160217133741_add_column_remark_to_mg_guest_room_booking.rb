class AddColumnRemarkToMgGuestRoomBooking < ActiveRecord::Migration
  def change
    add_column :mg_guest_room_bookings, :remark, :text
  end
end
