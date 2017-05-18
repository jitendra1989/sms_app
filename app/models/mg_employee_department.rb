class MgEmployeeDepartment < ActiveRecord::Base

	has_many :mg_employee_attendances
	has_many :mg_employees,:dependent => :destroy
    accepts_nested_attributes_for :mg_employees
end
