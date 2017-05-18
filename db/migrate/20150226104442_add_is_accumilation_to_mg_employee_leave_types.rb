class AddIsAccumilationToMgEmployeeLeaveTypes < ActiveRecord::Migration
  def change
  	add_column :mg_employee_leave_types, :is_accumilation, :boolean
  end
end
