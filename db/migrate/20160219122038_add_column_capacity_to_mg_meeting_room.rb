class AddColumnCapacityToMgMeetingRoom < ActiveRecord::Migration
  def change
    add_column :mg_meeting_rooms, :type_of_room, :string
    add_column :mg_meeting_rooms, :capacity, :integer
  end
end
