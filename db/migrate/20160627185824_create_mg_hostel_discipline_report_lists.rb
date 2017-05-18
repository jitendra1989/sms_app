class CreateMgHostelDisciplineReportLists < ActiveRecord::Migration
  def change
    create_table :mg_hostel_discipline_report_lists do |t|
      t.integer :mg_hostel_discipline_report
      t.integer :mg_student_id
      t.string :status
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
