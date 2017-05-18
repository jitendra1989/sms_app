class MgUserAlbum < ActiveRecord::Base
	belongs_to :mg_album
	belongs_to :mg_employee_department
	belongs_to :mg_batch
end
