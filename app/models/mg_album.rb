class MgAlbum < ActiveRecord::Base
	has_many :mg_user_albums
	belongs_to :mg_event


end
