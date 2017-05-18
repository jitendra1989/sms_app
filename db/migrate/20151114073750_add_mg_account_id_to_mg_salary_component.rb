class AddMgAccountIdToMgSalaryComponent < ActiveRecord::Migration
  def change
  	add_column :mg_salary_components, :mg_account_id, :integer
  	add_column :mg_salary_components, :is_from_central, :boolean
  end
end
