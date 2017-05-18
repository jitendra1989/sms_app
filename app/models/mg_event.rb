class MgEvent < ActiveRecord::Base
	belongs_to :mg_event_type
	belongs_to :mg_school
	
	has_many :mg_exams
	has_many :mg_event_privacy
	has_many :mg_albums
	has_many :mg_guests



end
