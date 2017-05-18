class CreateMgHostelReallotmentRequests < ActiveRecord::Migration
  def change
    create_table :mg_hostel_reallotment_requests do |t|
      t.integer :mg_hostel_details_id
      t.integer :mg_hostel_floor_id
      t.integer :mg_hostel_room_type_id
      t.integer :mg_wing_id
      t.integer :mg_hostel_room_id
      t.text :reason
      t.string :status
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
