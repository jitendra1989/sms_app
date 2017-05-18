class MgTimeTableChangeEntry < ActiveRecord::Base

	belongs_to :mg_time_table_entry
	belongs_to :mg_subject
	belongs_to :mg_employee
	belongs_to :mg_batch
	belongs_to :mg_class_timing
	belongs_to :mg_time_table

end
