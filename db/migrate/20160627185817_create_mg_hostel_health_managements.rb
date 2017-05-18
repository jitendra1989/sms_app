class CreateMgHostelHealthManagements < ActiveRecord::Migration
  def change
    create_table :mg_hostel_health_managements do |t|
      t.integer :mg_hostel_details_id
      t.integer :mg_hostel_floor_id
      t.integer :mg_hostel_room_id
      t.integer :mg_student_id
      t.date :date
      t.text :reason
      t.string :status
      t.integer :created_by
      t.integer :updated_by
      t.boolean :is_deleted
      t.integer :mg_school_id

      t.timestamps
    end
  end
end
