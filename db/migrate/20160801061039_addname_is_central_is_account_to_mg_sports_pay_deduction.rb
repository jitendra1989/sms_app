class AddnameIsCentralIsAccountToMgSportsPayDeduction < ActiveRecord::Migration
  def change
  	add_column :mg_sports_pay_deductions, :name, :string
  	add_column :mg_sports_pay_deductions, :is_central, :boolean
  	add_column :mg_sports_pay_deductions, :is_account, :boolean
  end
end
