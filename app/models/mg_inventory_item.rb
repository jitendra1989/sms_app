class MgInventoryItem < ActiveRecord::Base
   validates :name, :uniqueness => {:scope => [:mg_school_id, :is_deleted]}
   validates :code, :uniqueness => {:scope => [:mg_school_id, :is_deleted]}
   validates :prefix, :uniqueness => {:scope => [:mg_school_id, :is_deleted]}

   has_many :mg_document_managements 
   has_many :mg_alumni_item_sale_details
end
