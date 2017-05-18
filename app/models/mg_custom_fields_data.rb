class MgCustomFieldsData < ActiveRecord::Base
	belongs_to :mg_user
	belongs_to :mg_custom_field
	belongs_to :mg_school

end
