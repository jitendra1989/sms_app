class AddReasonToMgEmployeePayslipComponents < ActiveRecord::Migration
  def change
    add_column :mg_employee_payslip_components, :reason, :text
  end
end
