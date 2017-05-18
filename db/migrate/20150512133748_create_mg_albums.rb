class CreateMgAlbums < ActiveRecord::Migration
  def change
    create_table :mg_albums do |t|
      t.string :name
      t.integer :mg_event_id
      t.string :description
      t.integer :mg_employee_department_id
      t.integer :mg_batch_id
      t.boolean :accessable_to­_employees
      t.boolean :accessable_to­_students
      t.boolean :accessable_to­_guardians
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
