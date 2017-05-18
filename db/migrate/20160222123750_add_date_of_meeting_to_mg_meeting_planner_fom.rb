class AddDateOfMeetingToMgMeetingPlannerFom < ActiveRecord::Migration
  def change
    add_column :mg_meeting_planner_foms, :date_of_meeting, :date
  end
end
