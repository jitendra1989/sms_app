class CreateMgMeetingRooms < ActiveRecord::Migration
  def change
    create_table :mg_meeting_rooms do |t|
      t.string :room_no
      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end

