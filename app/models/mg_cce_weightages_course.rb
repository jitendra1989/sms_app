class MgCceWeightagesCourse < ActiveRecord::Base
	belongs_to :mg_cce_weightage
	belongs_to :mg_course
	belongs_to :mg_school
end
