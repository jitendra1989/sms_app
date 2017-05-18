class AddColumnDeductionToMgSportPayslipComponent < ActiveRecord::Migration
  def change
    add_column :mg_sport_payslip_components, :deduction, :boolean
  end
end
