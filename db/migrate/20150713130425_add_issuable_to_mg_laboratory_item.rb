class AddIssuableToMgLaboratoryItem < ActiveRecord::Migration
  def change
    add_column :mg_laboratory_items, :is_issuable, :boolean
  end
end
