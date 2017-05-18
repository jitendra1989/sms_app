class CreateMgTransports < ActiveRecord::Migration
  def change
    create_table :mg_transports do |t|
      t.string :route_name
      t.text :description
      t.integer :mg_vehicle_id
      t.integer :mg_employee_id
      t.time :drop_start_time
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by
      t.integer :mg_employee_category_id
      t.integer :mg_employee_position_id

      t.timestamps
    end
  end
end
