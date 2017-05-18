class CreateMgCheckUpSchedules < ActiveRecord::Migration
  def change
    create_table :mg_check_up_schedules do |t|
      t.string :doctor_name
      t.integer :mg_check_up_type_id
      t.date :date
      t.time :start_time
      t.time :end_time
      t.string :checkup_for
      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by
      t.timestamps
    end
  end
end

