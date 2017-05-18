class CreateMgAlumniGetTogethers < ActiveRecord::Migration
  def change
    create_table :mg_alumni_get_togethers do |t|
      t.string :event_name
      t.date :event_date
      t.time :start_time
      t.time :end_time
      t.text :venue
      t.string :status
      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
