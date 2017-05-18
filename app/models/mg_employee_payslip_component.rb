class MgEmployeePayslipComponent < ActiveRecord::Base
	belongs_to :mg_employee_payslip_detail
	belongs_to :mg_salary_component
end
