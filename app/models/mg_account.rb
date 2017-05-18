class MgAccount < ActiveRecord::Base
	validates_uniqueness_of :mg_account_name,  
  	scope: :mg_school_id,  
  	conditions: -> { where(is_deleted: false) }
end
