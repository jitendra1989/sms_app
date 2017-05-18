class CreateMgSyllabusTrackers < ActiveRecord::Migration
  def change
    create_table :mg_syllabus_trackers do |t|

      t.integer :mg_employee_id
      t.integer :mg_syllabus_id
      t.integer :mg_unit_id
      t.integer :mg_topic_id
      t.date :date

      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by
      t.timestamps
    end
  end
end
