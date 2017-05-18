class CreateMgTransportTimeManagements < ActiveRecord::Migration
  def change
    create_table :mg_transport_time_managements do |t|
      t.integer :mg_transport_id
      t.string :bus_stop_name
      t.time :pick_up_time
      t.time :drop_time
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
