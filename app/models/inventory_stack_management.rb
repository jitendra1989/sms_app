class InventoryStackManagement < ActiveRecord::Base
	validates_uniqueness_of :rack_no,
	scope: [:mg_school_id,:mg_inventory_room_management_id],
	conditions: -> { where(is_deleted: false) },on: :create

	validates_uniqueness_of :prefix,
	scope: [:mg_school_id,:mg_inventory_room_management_id],
	conditions: -> { where(is_deleted: false) },on: :create
      # validates :rack_no, :uniqueness => {:scope => [:mg_school_id,:mg_inventory_room_management_id]}
      # validates :prefix, :uniqueness => {:scope => [:mg_school_id,:mg_inventory_room_management_id]}
end
