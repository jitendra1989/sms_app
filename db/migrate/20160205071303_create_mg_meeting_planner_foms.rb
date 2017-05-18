class CreateMgMeetingPlannerFoms < ActiveRecord::Migration
  def change
    create_table :mg_meeting_planner_foms do |t|
      t.string :meeting_with
      t.text :purpose
      t.text :description
      t.date :date_of_meeting
      t.time :start_time
      t.time :end_time
      t.string :status
      t.text :remark
      t.text :principal_remark
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
