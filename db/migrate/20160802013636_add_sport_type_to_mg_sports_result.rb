class AddSportTypeToMgSportsResult < ActiveRecord::Migration
  def change
    add_column :mg_sports_results, :sport_type, :string
  end
end
