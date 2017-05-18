class ChangedatatypeInMgSportsPayDeduction < ActiveRecord::Migration
  def change
  	change_column :mg_sports_pay_deductions, :mm_yyyy,  :string
  end
end
