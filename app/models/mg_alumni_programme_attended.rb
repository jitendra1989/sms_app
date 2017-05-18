class MgAlumniProgrammeAttended < ActiveRecord::Base
	belongs_to :mg_wing
	delegate :wing_name,:to => :mg_wing
	# def course_batch_name
	# 	"#{course_name} - #{name}"
	# end	

	# def method_name
		
	# end
end
