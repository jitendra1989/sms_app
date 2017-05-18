class MgWeekday < ActiveRecord::Base
	
	belongs_to :mg_batch
	belongs_to :mg_school

	has_many :mg_class_timings
	has_many :mg_time_table_entries

end
