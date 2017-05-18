class CreateMgAllocateRoomLists < ActiveRecord::Migration
  def change
    create_table :mg_allocate_room_lists do |t|
      t.integer :mg_allocate_room_id
      t.integer :mg_student_id
      t.string :admission_number
      t.integer :mg_hostel_floor_id
      t.integer :mg_hostel_room_type_id
      t.integer :mg_hostel_room_id
      t.boolean :is_allocated
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
