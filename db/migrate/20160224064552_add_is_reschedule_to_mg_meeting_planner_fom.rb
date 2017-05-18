class AddIsRescheduleToMgMeetingPlannerFom < ActiveRecord::Migration
  def change
    add_column :mg_meeting_planner_foms, :is_reschedule, :boolean
  end
end
