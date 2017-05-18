class AddMgEmployeeLeaveApplicationIdToMgEmployeeAttendances < ActiveRecord::Migration
  def change
    add_column :mg_employee_attendances, :mg_employee_leave_application_id, :integer
  end
end
