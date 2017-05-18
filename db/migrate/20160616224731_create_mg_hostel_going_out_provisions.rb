class CreateMgHostelGoingOutProvisions < ActiveRecord::Migration
  def change
    create_table :mg_hostel_going_out_provisions do |t|
      t.text :reason
      t.date :from_date
      t.time :start_time
      t.date :to_date
      t.time :end_time
      t.string :status
      t.integer :mg_student_id
      t.integer :created_by
      t.integer :updated_by
      t.boolean :is_deleted
      t.integer :mg_school_id

      t.timestamps
    end
  end
end
