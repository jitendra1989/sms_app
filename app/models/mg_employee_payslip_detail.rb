class MgEmployeePayslipDetail < ActiveRecord::Base
    has_many :mg_employee_payslip_components
	  belongs_to :mg_employee
    has_many :mg_payslip_leave_details

end
