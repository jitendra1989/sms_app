class AddLeaveCalenderStartdateToMgSchools < ActiveRecord::Migration
  def change
    add_column :mg_schools, :mg_leave_calender_start_date, :date
  end
end
