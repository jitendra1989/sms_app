class ChangeDataTypeOfLeavenTakenToFloatInMgEmployeeLeaves < ActiveRecord::Migration
  def change
  	change_column :mg_employee_leaves, :leave_taken, :float
  end
end
