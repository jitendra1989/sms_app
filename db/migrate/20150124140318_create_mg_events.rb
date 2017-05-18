class CreateMgEvents < ActiveRecord::Migration
  def change
    create_table :mg_events do |t|
    	 t.string :title
      t.integer :mg_event_type_id
      t.string :event_privacy
      t.string :event_description
      t.time :start_time
      t.time :end_time
      t.date :event_date
      t.date :end_date
      t.boolean :all_day
      t.boolean :editable

      
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by
      t.timestamps
    end
  end
end
