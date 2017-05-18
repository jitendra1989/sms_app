class AddIsCancelledToMgMeetingDetail < ActiveRecord::Migration
  def change
    add_column :mg_meeting_details, :is_cancelled, :boolean
  end
end
