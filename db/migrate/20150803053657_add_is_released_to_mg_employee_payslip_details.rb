class AddIsReleasedToMgEmployeePayslipDetails < ActiveRecord::Migration
  def change
    add_column :mg_employee_payslip_details, :is_released, :boolean
  end
end
