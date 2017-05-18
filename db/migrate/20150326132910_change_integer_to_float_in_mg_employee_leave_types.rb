class ChangeIntegerToFloatInMgEmployeeLeaveTypes < ActiveRecord::Migration
  def change
  	change_column :mg_employee_leave_types, :max_leave_count, :float
  end
end
