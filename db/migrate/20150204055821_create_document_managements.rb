class CreateDocumentManagements < ActiveRecord::Migration
  def change
    create_table :document_managements do |t|
      t.string :name
      t.string :document_type
      t.string :access_type
      t.attachment :file
      t.integer :mg_user_id

      t.boolean :is_transfer_certificate_produced

      
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
