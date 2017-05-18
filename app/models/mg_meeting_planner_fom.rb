class MgMeetingPlannerFom < ActiveRecord::Base
	validates :start_time, :end_time, :overlap => {:scope => ["date_of_meeting","mg_school_id"],:query_options => {:active => nil} }
    scope :active, -> { where(:is_deleted => false,:status=>"Accepted") }
end
