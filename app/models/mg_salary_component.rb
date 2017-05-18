class MgSalaryComponent < ActiveRecord::Base
	# mg_salary_components
	has_many :mg_grade_components 
	has_many :mg_employee_grade_components
	has_many :mg_employee_payslip_components
end
