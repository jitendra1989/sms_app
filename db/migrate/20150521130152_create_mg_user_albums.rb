class CreateMgUserAlbums < ActiveRecord::Migration
  def change
    create_table :mg_user_albums do |t|
      t.integer :mg_album_id
      t.integer :mg_batch_id
      t.integer :mg_employee_department_id
      t.boolean :accessable_to_employees
      t.boolean :accessable_to_students
      t.boolean :accessable_to_guardians
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
