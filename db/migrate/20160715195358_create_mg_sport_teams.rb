class CreateMgSportTeams < ActiveRecord::Migration
  def change
    create_table :mg_sport_teams do |t|
      t.string :game_type
      t.integer :mg_sport_game_id
      t.string :team_name
      t.string :team_of
      t.integer :created_by
      t.integer :updated_by
      t.boolean :is_deleted
      t.integer :mg_school_id

      t.timestamps
    end
  end
end
