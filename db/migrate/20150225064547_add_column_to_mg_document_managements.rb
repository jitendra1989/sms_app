class AddColumnToMgDocumentManagements < ActiveRecord::Migration
  def change
  	add_column :mg_document_managements, :document_type, :string
  	add_column :mg_document_managements, :access_type, :string
  end
end
