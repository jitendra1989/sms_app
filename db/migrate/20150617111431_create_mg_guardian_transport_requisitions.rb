class CreateMgGuardianTransportRequisitions < ActiveRecord::Migration
  def change
    create_table :mg_guardian_transport_requisitions do |t|
      t.integer :mg_student_id
      t.integer :mg_transport_id
      t.integer :mg_transport_time_management_id
      t.string :confirmation_status
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by
      t.date :applied_date
      t.integer :mg_vehicle_id

      t.timestamps
    end
  end
end
