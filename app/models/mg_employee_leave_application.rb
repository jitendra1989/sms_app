class MgEmployeeLeaveApplication < ActiveRecord::Base

	has_many :mg_employee_leave_types
	has_many :mg_employee_attendances

# 	delegate :leave_name,:to => :mg_employee_leave_types
	
# def leave_type_name
# 		"#{leave_name}"
# 	end	
end
