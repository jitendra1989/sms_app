class MgVaccination < ActiveRecord::Base
  has_many :mg_vaccination_details
  # validates_uniqueness_of :name, scope: :mg_school_id, conditions: -> { where(is_deleted: false) }
end
