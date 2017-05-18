class AddMgUserIdToMgAccountCentralIncharge < ActiveRecord::Migration
  def change
  	add_column :mg_account_central_incharges, :mg_user_id, :integer
  end
end
