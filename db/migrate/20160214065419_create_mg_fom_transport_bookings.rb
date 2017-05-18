class CreateMgFomTransportBookings < ActiveRecord::Migration
  def change
    create_table :mg_fom_transport_bookings do |t|
      t.date :date_of_booking
      t.time :transport_time
      t.string :place_from
      t.string :place_to
      t.integer :way_mode
      t.integer :mg_employee_category_id
      t.integer :mg_employee_position_id
      t.integer :mg_employee_id
      t.text :purpose
      t.string :status
      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
