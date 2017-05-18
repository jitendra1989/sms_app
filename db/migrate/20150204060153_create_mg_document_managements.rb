class CreateMgDocumentManagements < ActiveRecord::Migration
  def change
    create_table :mg_document_managements do |t|
      t.string :name
      t.attachment :file
      t.integer :mg_employee_id
      t.integer :mg_employee_folder_id
      
      t.integer :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.integer :mg_add_report_id
      t.timestamps
    end
  end
end
