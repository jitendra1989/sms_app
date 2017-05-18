class CreateMgAllocateRooms < ActiveRecord::Migration
  def change
    create_table :mg_allocate_rooms do |t|
      t.integer :mg_hostel_details_id
      t.integer :mg_wing_id
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
