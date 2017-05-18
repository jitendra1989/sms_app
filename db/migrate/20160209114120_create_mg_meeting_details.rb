class CreateMgMeetingDetails < ActiveRecord::Migration
  def change
    create_table :mg_meeting_details do |t|
      t.integer :mg_meeting_room_id
      t.date :start_date
      t.time :start_time
      t.date :end_date
      t.time :end_time
      t.integer :mg_employee_id
      t.text :meeting_purpose

      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end

