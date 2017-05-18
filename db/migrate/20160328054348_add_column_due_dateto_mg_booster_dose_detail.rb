class AddColumnDueDatetoMgBoosterDoseDetail < ActiveRecord::Migration
  def change
    add_column :mg_booster_dose_details, :due_date, :date
  end
end
