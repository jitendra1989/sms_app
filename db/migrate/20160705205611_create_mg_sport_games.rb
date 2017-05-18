class CreateMgSportGames < ActiveRecord::Migration
  def change
    create_table :mg_sport_games do |t|
      t.string :name
      t.string :game_type
      t.text :description
      t.integer :created_by
      t.integer :updated_by
      t.boolean :is_deleted
      t.integer :mg_school_id

      t.timestamps
    end
  end
end
