class CreateMgComplainHostels < ActiveRecord::Migration
  def change
    create_table :mg_complain_hostels do |t|
      t.integer :mg_hostel_details_id
      t.string :room_no
      t.text :reason
      t.string :programme
      t.date :date
      t.string :status
      t.integer :mg_student_id
      
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by
      t.boolean :is_deleted

      t.timestamps
    end
  end
end
