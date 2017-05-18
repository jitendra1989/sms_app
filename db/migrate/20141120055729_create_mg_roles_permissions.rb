class CreateMgRolesPermissions < ActiveRecord::Migration
  def change
    create_table :mg_roles_permissions do |t|
    	t.integer 'mg_role_id'
    	t.integer 'mg_permission_id'

    	# audit fields
     #  t.boolean 'is_deleted'
     #  t.integer 'mg_school_id'
    	# t.integer 'created_by'
    	# t.integer 'updated_by'
      t.timestamps
    end
  end
end
