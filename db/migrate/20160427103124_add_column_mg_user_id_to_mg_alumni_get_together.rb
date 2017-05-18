class AddColumnMgUserIdToMgAlumniGetTogether < ActiveRecord::Migration
  def change
    add_column :mg_alumni_get_togethers, :mg_user_id, :integer
  end
end
