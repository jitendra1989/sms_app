class CreateMgAssignments < ActiveRecord::Migration
  def change
    create_table :mg_assignments do |t|
      t.integer :mg_employee_id
      t.integer :mg_subject_id
      t.integer :mg_batch_id
      t.string :title
      t.text :detail
      t.date :due_date
      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
