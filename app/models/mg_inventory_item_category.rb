class MgInventoryItemCategory < ActiveRecord::Base
         validates :name, :uniqueness => {:scope => [:mg_school_id, :is_deleted]}
end
