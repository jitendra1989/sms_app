class AddIsPrincipalToMgMeetingPlannerFom < ActiveRecord::Migration
  def change
    add_column :mg_meeting_planner_foms, :is_principal, :boolean
  end
end
