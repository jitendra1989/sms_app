class AddIsApprovedToMgEmployeePayslipDetails < ActiveRecord::Migration
  def change
    # add_column :mg_employee_payslip_details, :is_approved, :string
     # add_column :mg_employee_payslip_details, :no_of_payable_days_in_the_month, :float
     # add_column :mg_employee_payslip_details, :no_of_payable_days_in_the_month, :float
     # add_column :mg_employee_payslip_details, :leaves_taken_till_date_in_the_year, :float
     # add_column :mg_employee_payslip_details, :leave_balance, :float
     # add_column :mg_employee_payslip_details, :total_leave, :float
     # add_column :mg_employee_payslip_details, :total_Gross_salary, :float
     add_column :mg_employee_payslip_details, :total_net_amount, :float

     
  end
end
