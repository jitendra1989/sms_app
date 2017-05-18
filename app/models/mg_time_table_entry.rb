class MgTimeTableEntry < ActiveRecord::Base

	belongs_to :mg_batch
	belongs_to :mg_weekday
	belongs_to :mg_time_table
	# not found any relation
#	belongs_to :mg_class_timing
	belongs_to :mg_subject
	belongs_to :mg_employee
	belongs_to :mg_school

	delegate :weekday, :to => :mg_weekday
end

