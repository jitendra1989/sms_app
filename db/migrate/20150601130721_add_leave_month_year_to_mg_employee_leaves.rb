class AddLeaveMonthYearToMgEmployeeLeaves < ActiveRecord::Migration
  def change
    add_column :mg_employee_leaves, :leave_month_year, :date
  
  end
end
