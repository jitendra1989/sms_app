class AddActivityGameTypeToMgSportGame < ActiveRecord::Migration
  def change
    add_column :mg_sport_games, :activity_game_type, :string
  end
end
