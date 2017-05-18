class RenameLeaveCalenderStartdate < ActiveRecord::Migration
  def change
  	rename_column :mg_schools, :mg_leave_calender_start_date, :mg_leave_calendar_start_date
  end
end
