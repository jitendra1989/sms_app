class CreateMgBatchDocuments < ActiveRecord::Migration
  def change
    create_table :mg_batch_documents do |t|
      t.integer :mg_employee_id
      t.integer :mg_batch_id
      t.integer :mg_document_management_id
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
