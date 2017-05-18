class ChangeStatusInMgEmployees < ActiveRecord::Migration
  def change
  	change_column :mg_employees, :status, :string
  end
end
