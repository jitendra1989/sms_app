class ChangeMgEmployeeIdToMgUserId < ActiveRecord::Migration
  def change
  	rename_column :mg_document_managements, :mg_employee_id, :mg_user_id
  end
end
