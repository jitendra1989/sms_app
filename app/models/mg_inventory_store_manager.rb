class MgInventoryStoreManager < ActiveRecord::Base
  validates_uniqueness_of :mg_inventory_store_management_id,  
      scope: :mg_school_id,  
      conditions: -> { where(is_deleted: false) },on: :create
end
