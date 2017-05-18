class AddDateOfQueryToMgQueryRecord < ActiveRecord::Migration
  def change
    add_column :mg_query_records, :date_of_query, :date
  end
end
