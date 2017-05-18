class MgSyllabusTracker < ActiveRecord::Base
	belongs_to :mg_employees
	belongs_to :mg_syllabus
	belongs_to :mg_unit
	belongs_to :mg_topic

end
