class ChangeDecimalToFloatInMgEmployeeLeaveTypes < ActiveRecord::Migration
  def change
  	change_column :mg_employee_leave_types, :accumilation_count, :float
  end
end
