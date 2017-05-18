class MgObservationGroup < ActiveRecord::Base
	belongs_to :mg_cce_grades_set
	belongs_to :mg_school

	has_many :mg_course_observation_groups
end
