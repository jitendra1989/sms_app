class CreateMgGuestRoomBookings < ActiveRecord::Migration
  def change
    create_table :mg_guest_room_bookings do |t|
      t.integer :mg_fom_room_creation_id
      t.date :start_date
      t.date :end_date
      t.integer :mg_employee_category_id
      t.integer :mg_employee_position_id
      t.integer :mg_employee_id
      t.text :purpose
      t.integer :status
      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
