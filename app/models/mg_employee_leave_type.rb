class MgEmployeeLeaveType < ActiveRecord::Base
	belongs_to :mg_school

	has_many :mg_employee_attendances
end
