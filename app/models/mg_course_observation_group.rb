class MgCourseObservationGroup < ActiveRecord::Base
	belongs_to :mg_observation_group
	belongs_to :mg_course
	belongs_to :mg_school
end
