class AddIsOccupiableOldToMgHostelRooms < ActiveRecord::Migration
  def change
    add_column :mg_hostel_rooms, :is_occupiable_old, :boolean
  end
end
