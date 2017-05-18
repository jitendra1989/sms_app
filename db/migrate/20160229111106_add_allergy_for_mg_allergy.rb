class AddAllergyForMgAllergy < ActiveRecord::Migration
  def change
  	add_column :mg_allergies ,:allergy_for ,:string
  end
end
