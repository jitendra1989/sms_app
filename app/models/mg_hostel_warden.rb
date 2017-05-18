class MgHostelWarden < ActiveRecord::Base
 # validates :mg_hostel_details_id, :uniqueness => {:scope => [:mg_user_id],
 #  conditions: -> { where(is_deleted: false) }}
end
