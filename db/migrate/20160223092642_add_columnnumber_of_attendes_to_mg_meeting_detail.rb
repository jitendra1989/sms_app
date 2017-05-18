class AddColumnnumberOfAttendesToMgMeetingDetail < ActiveRecord::Migration
  def change
    add_column :mg_meeting_details, :number_of_attendees, :integer
  end
end
