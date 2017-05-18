class MgEmployeeSubject < ActiveRecord::Base
	belongs_to :mg_employee
	belongs_to :mg_subject
	belongs_to :mg_school
	# belongs_to :mg_course


	

end
