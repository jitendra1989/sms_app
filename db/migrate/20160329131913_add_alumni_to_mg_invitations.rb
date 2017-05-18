class AddAlumniToMgInvitations < ActiveRecord::Migration
  def change
    add_column :mg_invitations, :alumni, :boolean
    add_column :mg_invitations, :time_table_year, :integer
    add_column :mg_invitations, :mg_wing_id, :integer
    
  end
end
