class MgGradeComponent < ActiveRecord::Base
	
		
	belongs_to :mg_employee_grade
	belongs_to :mg_salary_component
  	
end
