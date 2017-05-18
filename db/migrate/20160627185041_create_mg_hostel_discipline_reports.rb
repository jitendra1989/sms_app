class CreateMgHostelDisciplineReports < ActiveRecord::Migration
  def change
    create_table :mg_hostel_discipline_reports do |t|
      t.integer :mg_hostel_details_id
      t.date :date_of_report
      t.text :reason
      t.text :action_to_be_taken
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
