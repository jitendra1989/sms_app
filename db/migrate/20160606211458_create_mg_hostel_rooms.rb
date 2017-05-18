class CreateMgHostelRooms < ActiveRecord::Migration
  def change
    create_table :mg_hostel_rooms do |t|
      t.integer :mg_hostel_details_id
      t.integer :mg_hostel_floor_id
      t.integer :mg_hostel_room_type_id
      t.string :name
      t.integer :capacity
      t.boolean :is_occupiable
      t.text :reason
      t.integer :created_by
      t.integer :updated_by
      t.boolean :is_deleted
      t.integer :mg_school_id

      t.timestamps
    end
  end
end
