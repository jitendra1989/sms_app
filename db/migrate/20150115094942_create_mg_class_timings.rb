class CreateMgClassTimings < ActiveRecord::Migration
  def change
    create_table :mg_class_timings do |t|
      t.integer :mg_batch_id
      t.integer :mg_weekday_id
      t.integer :mg_wing_id
      t.string :name
      t.time :start_time
      t.time :end_time
      t.boolean :is_break

      #Audit fields
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
