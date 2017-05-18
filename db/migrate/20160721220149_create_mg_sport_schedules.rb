class CreateMgSportSchedules < ActiveRecord::Migration
  def change
    create_table :mg_sport_schedules do |t|
      t.string :game_type
      t.integer :mg_sport_game_id
      t.integer :mg_sport_team_id1
      t.integer :mg_sport_team_id2
      t.string :guest_team
      t.date :start_date
      t.time :start_time
      t.date :end_date
      t.time :end_time
      t.string :venue
      t.string :winner
      t.integer :created_by
      t.integer :updated_by
      t.boolean :is_deleted
      t.integer :mg_school_id

      t.timestamps
    end
  end
end
