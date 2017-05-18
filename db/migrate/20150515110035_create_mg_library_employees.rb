class CreateMgLibraryEmployees < ActiveRecord::Migration
  def change
    create_table :mg_library_employees do |t|
      t.integer :mg_employee_id
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.string :designation
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
