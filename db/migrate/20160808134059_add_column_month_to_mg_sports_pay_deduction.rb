class AddColumnMonthToMgSportsPayDeduction < ActiveRecord::Migration
  def change
    add_column :mg_sports_pay_deductions, :month, :integer
    add_column :mg_sports_pay_deductions, :year, :integer
  end
end
