class AddColumnDatetoMgVaccinationDetail < ActiveRecord::Migration
  def change
    add_column :mg_vaccination_details, :date, :date
  end
end
