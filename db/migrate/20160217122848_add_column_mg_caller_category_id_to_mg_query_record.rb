class AddColumnMgCallerCategoryIdToMgQueryRecord < ActiveRecord::Migration
  def change
    add_column :mg_query_records, :mg_caller_category_id, :integer
  end
end
