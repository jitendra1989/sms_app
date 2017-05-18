class AddMgUserIdToMgAccount < ActiveRecord::Migration
  def change
  	add_column :mg_accounts, :mg_user_id, :integer
  end
end
