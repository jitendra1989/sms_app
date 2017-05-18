class MgBedDetail < ActiveRecord::Base

  validates_uniqueness_of :bed_no,  
  	scope: :mg_school_id,  
  	conditions: -> { where(is_deleted: false) }
end
