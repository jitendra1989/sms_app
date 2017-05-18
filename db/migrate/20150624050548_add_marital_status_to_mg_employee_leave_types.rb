class AddMaritalStatusToMgEmployeeLeaveTypes < ActiveRecord::Migration
  def change
    add_column :mg_employee_leave_types, :marital_status, :string
    add_column :mg_employee_leave_types, :is_showable	, :boolean

  end
end
