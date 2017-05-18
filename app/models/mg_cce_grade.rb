class MgCceGrade < ActiveRecord::Base

	belongs_to :mg_cce_grades_set
	belongs_to :mg_school

end
