class MgMealCategory < ActiveRecord::Base
  validates_uniqueness_of :priority, scope: :mg_school_id, conditions: -> { where(is_deleted: false) }
end
