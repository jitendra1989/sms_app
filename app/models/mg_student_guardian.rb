class MgStudentGuardian < ActiveRecord::Base
	belongs_to :mg_student
	belongs_to :mg_guardian
end
