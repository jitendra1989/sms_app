class AddMgAvailableLeaveToMgEmployeeLeaves < ActiveRecord::Migration
  def change
    add_column :mg_employee_leaves, :available_leave, :float
  end
end
