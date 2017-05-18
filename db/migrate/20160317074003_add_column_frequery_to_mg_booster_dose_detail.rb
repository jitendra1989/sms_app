class AddColumnFrequeryToMgBoosterDoseDetail < ActiveRecord::Migration
  def change
    add_column :mg_booster_dose_details ,:name ,:string
    add_column :mg_booster_dose_details ,:frequency ,:string
    add_column :mg_booster_dose_details ,:is_particular_student ,:boolean
  end
end
