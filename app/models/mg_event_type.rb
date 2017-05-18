class MgEventType < ActiveRecord::Base
	belongs_to :mg_school

	has_many :mg_events
end
