class MgEmployeeGradeComponent < ActiveRecord::Base
	belongs_to :mg_employee
	belongs_to :mg_salary_component
end
