class AddIsCancelledToMgGuestRoomBooking < ActiveRecord::Migration
  def change
    add_column :mg_guest_room_bookings, :is_cancelled, :boolean
  end
end
