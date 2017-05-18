class CreateMgHelpDocuments < ActiveRecord::Migration
  def change
    create_table :mg_help_documents do |t|
      t.integer :mg_school_id
      t.string :user_type
      t.string :name
      t.attachment :document
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
