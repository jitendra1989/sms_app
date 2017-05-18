class ChangeStringToDecimalInMgEmployeeLeaveTypes < ActiveRecord::Migration
  def change
  	change_column :mg_employee_leave_types, :accumilation_count, :decimal
  end
end
