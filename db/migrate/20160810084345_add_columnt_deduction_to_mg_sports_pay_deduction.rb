class AddColumntDeductionToMgSportsPayDeduction < ActiveRecord::Migration
  def change
    add_column :mg_sports_pay_deductions, :deduction, :boolean
  end
end
