class CreateMgHostelProgrammeQuota < ActiveRecord::Migration
  def change
    create_table :mg_hostel_programme_quota do |t|
      t.integer :mg_hostel_details_id
      t.integer :programme
      t.integer :max_occupancy
      t.integer :created_by
      t.integer :updated_by
      t.boolean :is_deleted
      t.integer :mg_school_id

      t.timestamps
    end
  end
end
