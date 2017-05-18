class AddLtcApplicableToMgEmployees < ActiveRecord::Migration
  def change
    add_column :mg_employees, :is_ltc_applicable, :boolean
  end
end
