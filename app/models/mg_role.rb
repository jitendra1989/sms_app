class MgRole < ActiveRecord::Base
	 belongs_to :mg_roles_permission
	 belongs_to :mg_user_role
end
