class MgBoosterDose < ActiveRecord::Base
  has_many :mg_booster_dose_details
  validates_uniqueness_of :name, scope: :mg_school_id, conditions: -> { where(is_deleted: false) }
end
