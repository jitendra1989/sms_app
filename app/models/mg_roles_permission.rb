class MgRolesPermission < ActiveRecord::Base

	has_many :mg_permissions
	has_many :mg_roles
end
