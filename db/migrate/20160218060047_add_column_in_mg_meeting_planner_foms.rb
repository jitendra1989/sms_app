class AddColumnInMgMeetingPlannerFoms < ActiveRecord::Migration
  def change
  	add_column :mg_meeting_planner_foms, :end_date_of_meeting, :datetime
  	rename_column :mg_meeting_planner_foms, :date_of_meeting, :start_date_of_meeting
  	change_column :mg_meeting_planner_foms, :start_date_of_meeting, :datetime
  end
end
