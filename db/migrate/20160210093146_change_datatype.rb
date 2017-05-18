class ChangeDatatype < ActiveRecord::Migration
  def change
   change_table :mg_guest_room_bookings do |t|
      t.change :status, :string
  end
  end
end
