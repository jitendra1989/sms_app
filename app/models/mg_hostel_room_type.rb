class MgHostelRoomType < ActiveRecord::Base
  validates_uniqueness_of :name, scope: :mg_school_id, conditions: -> { where(is_deleted: false) }
end
