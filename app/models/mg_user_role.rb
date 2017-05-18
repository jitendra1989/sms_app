class MgUserRole < ActiveRecord::Base
	has_many :mg_users
	has_many :mg_roles
end
