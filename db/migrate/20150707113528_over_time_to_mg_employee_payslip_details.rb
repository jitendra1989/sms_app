class OverTimeToMgEmployeePayslipDetails < ActiveRecord::Migration
  def change
  	add_column :mg_employee_payslip_details, :over_time, :float
  end
end
