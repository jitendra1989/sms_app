class CreateMgSportsResults < ActiveRecord::Migration
  def change
    create_table :mg_sports_results do |t|
      t.integer :mg_event_committee_id
      t.integer :mg_event_id
      t.date :date_of_event
      t.integer :mg_sport_game_id
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by
      t.boolean :is_deleted

      t.timestamps
    end
  end
end
