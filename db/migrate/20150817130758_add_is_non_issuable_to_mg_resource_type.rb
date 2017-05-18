class AddIsNonIssuableToMgResourceType < ActiveRecord::Migration
  def change
    add_column :mg_resource_types, :is_non_issuable, :boolean
  end
end
