class AddColumnAgeRecommendedToMgVaccinationDetail < ActiveRecord::Migration
  def change
    add_column :mg_vaccination_details ,:name ,:string
    add_column :mg_vaccination_details ,:age_recommended ,:string
    add_column :mg_vaccination_details ,:is_particular_student ,:boolean
  end
end
