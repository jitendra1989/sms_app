class MgTimeTable < ActiveRecord::Base

validates :start_date, :end_date,:overlap => {:scope => "mg_school_id",:query_options => {:active => nil}}
  scope :active, -> { where(:is_deleted => false) }
 
	belongs_to :mg_school
	
	has_many :mg_time_table_entries
end
