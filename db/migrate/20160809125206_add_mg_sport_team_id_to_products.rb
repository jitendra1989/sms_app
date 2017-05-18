class AddMgSportTeamIdToProducts < ActiveRecord::Migration
  def change
    add_column :mg_sports_results, :mg_sport_team_id, :integer
  end
end
