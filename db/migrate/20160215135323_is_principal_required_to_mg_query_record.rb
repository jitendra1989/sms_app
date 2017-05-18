class IsPrincipalRequiredToMgQueryRecord < ActiveRecord::Migration
  def change
  	add_column :mg_query_records, :is_principal_required, :boolean
  end
end
