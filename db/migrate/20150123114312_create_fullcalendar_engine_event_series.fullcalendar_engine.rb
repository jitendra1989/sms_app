# This migration comes from fullcalendar_engine (originally 20131203105529)
class CreateFullcalendarEngineEventSeries < ActiveRecord::Migration
  def change
    create_table :fullcalendar_engine_event_series do |t|
      t.integer :frequency, :default => 1
      t.string :period, :default => 'monthly'
      t.datetime :starttime
      t.datetime :endtime
      t.boolean :all_day, :default => false

      #audit field
      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by
      t.timestamps
    end
  end
end
