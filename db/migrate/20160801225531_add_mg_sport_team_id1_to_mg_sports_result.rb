class AddMgSportTeamId1ToMgSportsResult < ActiveRecord::Migration
  def change
    add_column :mg_sports_results, :mg_sport_team_id1, :integer
    add_column :mg_sports_results, :mg_sport_team_id2, :integer
    add_column :mg_sports_results, :guest_team, :string
    add_column :mg_sports_results, :venue, :text
    add_column :mg_sports_results, :winner, :text


  end
end
