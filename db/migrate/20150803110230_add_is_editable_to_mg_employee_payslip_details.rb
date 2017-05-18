class AddIsEditableToMgEmployeePayslipDetails < ActiveRecord::Migration
  def change
    add_column :mg_employee_payslip_details, :is_editable, :boolean
    add_column :mg_employee_payslip_details, :reason, :text

  end
end
