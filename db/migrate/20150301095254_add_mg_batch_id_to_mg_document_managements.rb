class AddMgBatchIdToMgDocumentManagements < ActiveRecord::Migration
  def change
    add_column :mg_document_managements, :mg_batch_id, :integer
  end
end
