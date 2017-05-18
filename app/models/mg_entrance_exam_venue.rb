class MgEntranceExamVenue < ActiveRecord::Base
  validates_uniqueness_of :institute_name, scope: :institute_name,  
  conditions: -> { where(is_deleted: false) }
end
