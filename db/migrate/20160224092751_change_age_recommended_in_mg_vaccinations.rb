class ChangeAgeRecommendedInMgVaccinations < ActiveRecord::Migration
  def up
    change_column :mg_vaccinations, :age_recommended, :string
  end

  def down
    change_column :mg_vaccinations, :age_recommended, :integer
  end
end
