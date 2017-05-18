class AddTeacherToMgInvitations < ActiveRecord::Migration
  def change
    add_column :mg_invitations, :teacher, :boolean
  end
end
