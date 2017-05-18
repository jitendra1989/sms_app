class AddMgSchoolIdToMgRolesPermssions < ActiveRecord::Migration
  def change
    add_column :mg_roles_permissions, :mg_school_id, :integer
  end
end
