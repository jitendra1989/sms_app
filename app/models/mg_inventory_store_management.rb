class MgInventoryStoreManagement < ActiveRecord::Base
      validates :store_name, :uniqueness => {:scope => [:mg_school_id]}

end
