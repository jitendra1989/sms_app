class CreateMgVehicles < ActiveRecord::Migration
  def change
    create_table :mg_vehicles do |t|
      t.string :vehicle_number
      t.string :make
      t.string :model
      t.date :date_of_purchase
      t.integer :no_of_seats
      t.date :Current_insurance_due_date
      t.date :last_service_date
      t.date :next_service_date
      t.boolean :is_under_repair
      t.date :repair_completion_date
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by
      t.float :last_insurance_amount
      t.string :vehicle_status
      t.integer :mg_transport_id
      t.integer :mg_employee_id
      t.time :drop_start_time
      t.integer :mg_employee_position_id
      t.integer :mg_employee_category_id
      t.timestamps
    end
  end
end
