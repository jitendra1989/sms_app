class CreateMgBedAssignments < ActiveRecord::Migration
  def change
    create_table :mg_bed_assignments do |t|
      t.integer :mg_bed_details_id
      t.date :admitted_date
      t.time :admitted_time
      t.date :discharge_date
      t.time :discharge_time
      t.string :user_id
      t.string :status
      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
