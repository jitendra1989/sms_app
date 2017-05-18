class MgPermission < ActiveRecord::Base

	belongs_to :mg_roles_permission

	has_many :mg_actions
	has_many :mg_models
end
