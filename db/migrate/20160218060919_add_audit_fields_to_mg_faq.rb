class AddAuditFieldsToMgFaq < ActiveRecord::Migration
  def change
    add_column :mg_faqs, :is_deleted, :boolean
    add_column :mg_faqs, :mg_school_id, :integer
    add_column :mg_faqs, :created_by, :integer
    add_column :mg_faqs, :updated_by, :integer
  end
end
