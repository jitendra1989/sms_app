class CreateMgEmployeeFolders < ActiveRecord::Migration
  def change
    create_table :mg_employee_folders do |t|
      t.string :folder_name
      t.integer :mg_employee_id
      # chaild need to change child
      t.integer :mg_employee_chaild_folder_id

      
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
