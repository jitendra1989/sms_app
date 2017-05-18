class MgCheckupType < ActiveRecord::Base
  has_many :mg_checkup_particulars
  validates_uniqueness_of :name, scope: :mg_school_id, conditions: -> { where(is_deleted: false) }
end
